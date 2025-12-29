{ config, ... }:
let
  whoAmIPort = 15558;
in
{
  services.whoami = {
    enable = true;
    port = whoAmIPort;
  };

  services.traefik = {
    enable = true;

    environmentFiles = [
      config.sops.secrets.traefik.path
    ];

    staticConfigOptions = {
      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          http.tls = {
            certResolver = "letsencrypt";
            domains = [
              {
                main = "fbozzo.dpdns.org";
                sans = [ "*.fbozzo.dpdns.org" ];
              }
            ];
          };
        };
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      # https://go-acme.github.io/lego/dns/cloudflare/index.html
      certificatesResolvers.letsencrypt.acme = {
        email = "francesco.bozzo.99@gmail.com";
        storage = "${config.services.traefik.dataDir}/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          delaybeforecheck = "0s";
          resolvers = [
            "1.1.1.1:53"
            "8.8.8.8:53"
          ];
        };
      };
      serversTransport = {
        insecureSkipVerify = true;
      };

      api = {
        insecure = true;
        dashboard = true;
        debug = false;
      };
    };

    dynamicConfigOptions = {
      http.routers = {
        whoami = {
          entryPoints = [ "websecure" ];
          rule = "Host(`whoami.fbozzo.dpdns.org`)";
          service = "whoami";
        };
        pihole = {
          entryPoints = [ "websecure" ];
          rule = "Host(`pihole.fbozzo.dpdns.org`)";
          service = "pihole";
        };
        webui = {
          entryPoints = [ "websecure" ];
          rule = "Host(`webui.fbozzo.dpdns.org`)";
          service = "webui";
        };
        hass = {
          entryPoints = [ "websecure" ];
          rule = "Host(`hass.fbozzo.dpdns.org`)";
          service = "hass";
        };
      };
      http.services = {
        whoami.loadBalancer = {
          servers = [ { url = "http://localhost:${toString whoAmIPort}"; } ];
        };
        pihole.loadBalancer = {
          servers = [ { url = "http://localhost:${toString 168}"; } ];
        };
        webui.loadBalancer = {
          servers = [ { url = "http://localhost:${toString 9090}"; } ];
        };
        hass.loadBalancer = {
          servers = [ { url = "http://localhost:${toString 8123}"; } ];
        };
      };
    };
  };

  sops.secrets.traefik = {
    format = "dotenv";
    restartUnits = [ "traefik.service" ];
    sopsFile = ./traefik-secrets.env;
    key = ""; # to map the whole file as a secret
  };
}
