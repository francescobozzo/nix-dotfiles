{
  flake.modules.nixos.monitoring =
    { lib, ... }:
    {
      services.gatus = {
        enable = true;
        settings = {
          web.port = 4325;
          storage = {
            type = "sqlite";
            path = "/var/lib/gatus/gatus.db";
            caching = true;
          };
          endpoints = [
            {
              name = "Glance";
              group = "fbozzo.dpdns.org";
              url = "https://glance.fbozzo.dpdns.org/api/healthz";
              interval = "5m";
              conditions = [
                "[STATUS] == 200"
                "[CONNECTED] == true"
                "[RESPONSE_TIME] < 500"
                "[CERTIFICATE_EXPIRATION] > 336h"
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
            }
          ];
        };
      };
    };
}
