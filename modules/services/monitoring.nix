{
  flake.modules.nixos.monitoring =
    { lib, ... }:
    {
      services.ntfy-sh = {
        enable = true;
        settings = {
          base-url = "https://ntfy.fbozzo.dpdns.org";

          # enable iOS push notifications
          # https://docs.ntfy.sh/config/#ios-instant-notifications
          upstream-base-url = "https://ntfy.sh";

          listen-http = "127.0.0.1:23445";
          behind-proxy = true;

          enable-login = true;
          enable-signup = true;
        };
      };

      services.gatus = {
        enable = true;
        settings = {
          web.port = 4325;
          storage = {
            type = "sqlite";
            path = "/var/lib/gatus/gatus.db";
            caching = true;
          };
          alerting = {
            ntfy = {
              url = "https://ntfy.fbozzo.dpdns.org";
              topic = "alerts";
              priority = 3;
              default-alert = {
                failure-thresqhold = 3;
                success-threshold = 2;
                send-on-resolved = true;
              };
            };
          };
          endpoints = [
            {
              name = "Glance";
              group = "fbozzo.dpdns.org";
              url = "https://glance.fbozzo.dpdns.org/api/healthz";
              interval = "1m";
              conditions = [
                "[STATUS] == 200"
                "[CONNECTED] == true"
                "[RESPONSE_TIME] < 500"
                "[CERTIFICATE_EXPIRATION] > 336h"
              ];
              alerts = [
                {
                  type = "ntfy";
                }
              ];
            }
            {
              name = "Immich";
              group = "fbozzo.dpdns.org";
              url = "https://photos.fbozzo.dpdns.org/";
              interval = "5m";
              conditions = [
                "[STATUS] == 200"
                "[CONNECTED] == true"
                "[RESPONSE_TIME] < 500"
                "[CERTIFICATE_EXPIRATION] > 336h"
              ];
              alerts = [
                {
                  type = "ntfy";
                }
              ];
            }
            {
              name = "llama-swap";
              group = "fbozzo.dpdns.org";
              url = "https://llama.fbozzo.dpdns.org/health";
              interval = "5m";
              conditions = [
                "[STATUS] == 200"
                "[CONNECTED] == true"
                "[RESPONSE_TIME] < 500"
                "[BODY] == OK"
                "[CERTIFICATE_EXPIRATION] > 336h"
              ];
              alerts = [
                {
                  type = "ntfy";
                }
              ];
            }
            {
              name = "searxng";
              group = "fbozzo.dpdns.org";
              url = "https://search.fbozzo.dpdns.org/healthz";
              interval = "5m";
              conditions = [
                "[STATUS] == 200"
                "[CONNECTED] == true"
                "[RESPONSE_TIME] < 500"
                "[BODY] == OK"
                "[CERTIFICATE_EXPIRATION] > 336h"
              ];
              alerts = [
                {
                  type = "ntfy";
                }
              ];
            }
            {
              name = "Pihole";
              group = "fbozzo.dpdns.org";
              url = "https://pihole.fbozzo.dpdns.org/api/stats/summary";
              # headers = {
              #   "X-FTL-SID" = "$\{PIHOLE_PASSWORD}";
              # };
              interval = "5m";
              conditions = [
                "[STATUS] == 200"
                "[CONNECTED] == true"
                "[RESPONSE_TIME] < 500"
                "[BODY].queries.total > 0" # We are receiving queries
                "[BODY].gravity.domains_being_blocked > 0" # We are using blocklists
                "[CERTIFICATE_EXPIRATION] > 336h"
              ];
              alerts = [
                {
                  type = "ntfy";
                }
              ];
            }
          ];
        };
      };
    };
}
