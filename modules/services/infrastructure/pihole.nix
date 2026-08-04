{
  flake.modules.nixos.pihole =
    { pkgs, config, ... }:
    {
      services.pihole-web = {
        enable = true;
        ports = [ 168 ];
      };

      services.pihole-ftl = {
        enable = true;
        package = pkgs.pihole-ftl;
        openFirewallDNS = true;
        openFirewallDHCP = true;
        privacyLevel = 0; # full visibility. Up to 3
        queryLogDeleter = {
          enable = true;
          age = 120; # days
        };
        lists = [
          # {
          #   url = "https://easylist.to/easylist/easylist.txt";
          #   type = "block";
          #   enabled = true;
          #   description = "EasyList";
          # }
          # {
          #   url = "https://easylist.to/easylist/easyprivacy.txt";
          #   type = "block";
          #   enabled = true;
          #   description = "EasyPrivacy";
          # }
          # {
          #   url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          #   type = "block";
          #   enabled = true;
          #   description = "Steven Black Hosts";
          # }
        ];
        settings = {
          dns = {
            listeningMode = "ALL";
            upstreams = [
              "8.8.8.8" # Google
              "2001:4860:4860::8888"
              "1.1.1.1" # Cloudflare
              "2606:4700:4700::1111"
              "9.9.9.11" # Quad9
              "2620:fe::11"
            ];
            hosts = [
              # split horizon dns with dnsmasq's localise-queries directive
              # https://discourse.pi-hole.net/t/pi-hole-tailscale-and-split-horizon/74407/9
              # TODO: split horizon dns with iOS hotspot tethering
              # https://github.com/tailscale/tailscale/issues/15352
              "192.168.1.89 fbozzo.dpdns.org"
              "100.76.213.79 fbozzo.dpdns.org"
            ]
            ++ (builtins.concatLists (
              map (service: [
                "192.168.1.89 ${service.subdomain}.fbozzo.dpdns.org"
                "100.76.213.79 ${service.subdomain}.fbozzo.dpdns.org"
              ]) config.fb.services
            ));
          };
          dhcp = {
            active = true;
            start = "192.168.1.100";
            end = "192.168.1.250";
            router = "192.168.1.254";
            ipv6 = true;
            logging = true;
            ignoreUnknownClients = false;
            hosts = [ ];
          };
        };
      };

      fb.services = [
        {
          name = "pihole";
          port = builtins.fromJSON config.services.pihole-web.ports;
          gatusHealthcheckEndpoint = "/api/stats/summary";
          category = "infrastructure";
          icon = "di:pi-hole";
          extraGatusConditions = [
            "[BODY].queries.total > 0"
            "[BODY].gravity.domains_being_blocked > 0"
          ];
          toBackup = [
            # config.services.pihole-ftl.stateDirectory # ~170MiB daily
          ];
        }
      ];
    };
}
