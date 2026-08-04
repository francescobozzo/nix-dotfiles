{
  flake.modules.nixos.traefik =
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
            insecureSkipVerify = true; # client ---HTTPS--> traefik ---HTTP--> service
          };

          api = {
            insecure = true;
            dashboard = true;
            debug = false;
          };
        };

        dynamicConfigOptions = {
          http.routers = builtins.listToAttrs (
            map (service: {
              name = service.name;
              value = {
                entryPoints = [ "websecure" ];
                rule = "Host(`${service.subdomain}.fbozzo.dpdns.org`)";
                service = service.name;
              };
            }) config.fb.services
          );

          http.services = builtins.listToAttrs (
            map (service: {
              name = service.name;
              value = {
                loadBalancer.servers = [
                  { url = "http://localhost:${toString service.port}"; }
                ];
              };
            }) config.fb.services
          );
        };
      };

      fb.services = [
        {
          name = "whoami";
          port = config.services.whoami.port;
          category = "misc";
          icon = "mdi:account";
        }
      ];
    };
}
