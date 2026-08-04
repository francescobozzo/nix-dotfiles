{
  flake.modules.nixos.immich =
    { config, pkgs, ... }:
    {
      services.immich = {
        enable = true;
        port = 2283;

        package = pkgs.unstable.immich;

        accelerationDevices = null;
        machine-learning.enable = true;

        environment = {
          IMMICH_LOG_LEVEL = "warn";
          IMMICH_API_METRICS_PORT = "50010";
          IMMICH_MICROSERVICES_METRICS_PORT = "50011";
          IMMICH_TELEMETRY_INCLUDE = "all";
          # IMMICH_ALLOW_SETUP = "false";
          # IMMICH_TELEMETRY_INCLUDE = "all";
        };
      };

      fb.services = [
        {
          name = "immich";
          subdomain = "photos";
          port = config.services.immich.port;
          category = "media";
          icon = "di:immich";
          toBackup = [
            "${config.services.immich.mediaLocation}/backups"
            "${config.services.immich.mediaLocation}/library"
            "${config.services.immich.mediaLocation}/upload"
            "${config.services.immich.mediaLocation}/profile"
          ];
        }
      ];

      users.users.immich.extraGroups = [
        "video"
        "render"
      ];
    };
}
