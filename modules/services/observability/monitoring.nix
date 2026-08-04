{
  flake.modules.nixos.monitoring =
    { lib, config, ... }:
    let
      ntfyPort = 23445;
      gatusService = {
        name = "gatus";
        subdomain = "gatus";
        port = config.services.gatus.settings.web.port;
        category = "observability";
        icon = "di:gatus";
        toBackup = [
          "/var/lib/gatus"
        ];
      };
      ntfyService = {
        name = "ntfy";
        subdomain = "ntfy";
        port = ntfyPort;
        category = "misc";
        icon = "mdi:bell-ring-outline";
      };
    in
    {
      services.ntfy-sh = {
        enable = true;
        settings = {
          base-url = "https://${ntfyService.subdomain}.fbozzo.dpdns.org";

          # enable iOS push notifications
          # https://docs.ntfy.sh/config/#ios-instant-notifications
          upstream-base-url = "https://ntfy.sh";

          listen-http = "127.0.0.1:${toString ntfyPort}";
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
              url = "https://${ntfyService.subdomain}.fbozzo.dpdns.org";
              topic = "alerts";
              priority = 3;
              default-alert = {
                failure-threshold = 3;
                success-threshold = 2;
                send-on-resolved = true;
              };
            };
          };
          endpoints = builtins.map (service: {
            name = service.name;
            group = service.category;
            url = "https://${service.subdomain}.fbozzo.dpdns.org${toString (service.gatusHealthcheckEndpoint or "")}";
            interval = "5m";
            conditions = [
              "[STATUS] == 200"
              "[CONNECTED] == true"
              "[RESPONSE_TIME] < 500"
              "[CERTIFICATE_EXPIRATION] > 96h"
            ]
            ++ service.extraGatusConditions;
            alerts = [
              {
                type = "ntfy";
              }
            ];
          }) config.fb.services;
        };
      };

      fb.services = [
        gatusService
        ntfyService
      ];
    };
}
