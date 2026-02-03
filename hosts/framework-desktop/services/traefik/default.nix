{ config, ... }:
{
  services.whoami = {
    enable = true;
    port = 15558;
  };

  networking.firewall.allowedTCPPorts = [
    443
  ];

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
      metrics = {
        prometheus = {
          addRoutersLabels = true;
          addServicesLabels = true;
          entryPoint = "metrics";
        };
      };
      entryPoints = {
        metrics = {
          address = ":8082";
        };
        web = {
          address = ":80";
          asDefault = true;
          http.sanitizePath = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          http.sanitizePath = true;
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
      accessLog = {
        filePath = "${config.services.traefik.dataDir}/access.json";
        format = "json";
        bufferingSize = 0; # collect logs as in-memory buffer before writing into log file
        fields = {
          headers = {
            defaultMode = "drop"; # drop all headers per default
            names = {
              User-Agent = "keep"; # log user agent strings
            };
          };
        };
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
        llm = {
          entryPoints = [ "websecure" ];
          rule = "Host(`llm.fbozzo.dpdns.org`)";
          service = "llm";
        };
        glance = {
          entryPoints = [ "websecure" ];
          rule = "Host(`glance.fbozzo.dpdns.org`)";
          service = "glance";
        };
        prometheus = {
          entryPoints = [ "websecure" ];
          rule = "Host(`prometheus.fbozzo.dpdns.org`)";
          service = "prometheus";
        };
        uptime = {
          entryPoints = [ "websecure" ];
          rule = "Host(`status.fbozzo.dpdns.org`)";
          service = "uptime";
        };
      };
      http.services = {
        whoami.loadBalancer = {
          servers = [
            { url = "http://localhost:${toString config.services.whoami.port}"; }
          ];
        };
        pihole.loadBalancer = {
          servers = [ { url = "http://localhost:${config.services.pihole-web.ports}"; } ];
        };
        webui.loadBalancer = {
          servers = [ { url = "http://localhost:${toString config.services.open-webui.port}"; } ];
        };
        hass.loadBalancer = {
          servers = [
            { url = "http://localhost:${toString config.services.home-assistant.config.http.server_port}"; }
          ];
        };
        llm.loadBalancer = {
          servers = [
            { url = "http://localhost:${toString config.services.ollama.port}"; }
          ];
        };
        glance.loadBalancer = {
          servers = [ { url = "http://localhost:${toString config.services.glance.settings.server.port}"; } ];
        };
        prometheus.loadBalancer = {
          servers = [ { url = "http://localhost:${toString config.services.prometheus.port}"; } ];
        };
        uptime.loadBalancer = {
          servers = [
            { url = "http://localhost:${config.services.uptime-kuma.settings.UPTIME_KUMA_PORT}"; }
          ];
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
