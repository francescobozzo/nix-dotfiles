{
  services.immich = {
    enable = true;
    port = 2283;

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

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
