{ pkgs-unstable, ... }:
{
  services.pihole-web = {
    enable = true;
    ports = [ 168 ];
  };

  services.pihole-ftl = {
    enable = true;
    package = pkgs-unstable.pihole-ftl;
    openFirewallDNS = true;
    openFirewallDHCP = true;
    privacyLevel = 0; # full visibility. Up to 3
    queryLogDeleter = {
      enable = true;
      age = 120; # days
    };
    lists = [
      {
        url = "https://easylist.to/easylist/easylist.txt";
        type = "block";
        enabled = true;
        description = "EasyList";
      }
      {
        url = "https://easylist.to/easylist/easyprivacy.txt";
        type = "block";
        enabled = true;
        description = "EasyPrivacy";
      }
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        type = "block";
        enabled = true;
        description = "Steven Black Hosts";
      }
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
          "192.168.1.89 whoami.fbozzo.dpdns.org"
          "100.76.213.79 whoami.fbozzo.dpdns.org"
          "192.168.1.89 pihole.fbozzo.dpdns.org"
          "100.76.213.79 pihole.fbozzo.dpdns.org"
          "192.168.1.89 webui.fbozzo.dpdns.org"
          "100.76.213.79 webui.fbozzo.dpdns.org"
          "192.168.1.89 hass.fbozzo.dpdns.org"
          "100.76.213.79 hass.fbozzo.dpdns.org"
          "192.168.1.89 llm.fbozzo.dpdns.org"
          "100.76.213.79 llm.fbozzo.dpdns.org"
          "192.168.1.89 glance.fbozzo.dpdns.org"
          "100.76.213.79 glance.fbozzo.dpdns.org"
        ];
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
}
