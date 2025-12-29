{
  pkgs,
  config,
  ...
}:
let
  hassUser = config.users.users.hass.name;
  hassGroup = config.users.users.hass.group;
  hassDir = config.services.home-assistant.configDir;
  tempResources =
    map (input: "${input.type} ${hassDir}/${input.path} 0644 ${hassUser} ${hassGroup}")
      [
        {
          type = "f";
          path = "automations.yaml";
        }
        {
          type = "f";
          path = "scripts.yaml";
        }
        {
          type = "d";
          path = "blueprints";
        }
      ];
in
{
  services.home-assistant = {
    enable = true;
    configDir = "/var/lib/hass";
    openFirewall = true;
    configWritable = false;
    extraComponents = [
      # search for https://www.home-assistant.io/integrations/[component]
      "default_config"
      "http"
      "prometheus"
      "met" # nowcasting
      "isal" # recommended for fast zlib compression
      "xiaomi_ble" # framework's bluetooth module
      "switchbot"

      # required for onboarding
      "google_translate"
      "radio_browser"
    ];
    extraPackages =
      python3Packages: with python3Packages; [
        zlib-ng
        zha
      ];
    customLovelaceModules = with pkgs; [
      home-assistant-custom-lovelace-modules.weather-card
      home-assistant-custom-lovelace-modules.mini-graph-card
      home-assistant-custom-lovelace-modules.bubble-card
    ];

    config = {
      default_config = { };

      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      homeassistant = {
        name = "Home";
        temperature_unit = "C";
        time_zone = "Europe/Rome";
        unit_system = "metric";
        currency = "EUR";
      };

      http = {
        server_port = 8123;
        server_host = [ "::1" ];
        ip_ban_enabled = true;
        login_attempts_threshold = 5;
        use_x_forwarded_for = true;
        trusted_proxies = [ "::1" ];
      };

      prometheus.namespace = "hass";

      network = { };
      dhcp = { };
      lovelace.mode = "yaml";
    };
  };

  # create temp files to bootstrap resources managed by the UI
  systemd.tmpfiles.rules = tempResources;

  # Home Assistant Bluetooth needs BlueZ running
  services.dbus.packages = [ pkgs.bluez ];
  users.users.hass.extraGroups = [
    "bluetooth"
    "netdev"
  ];
  systemd.services.home-assistant.serviceConfig = {
    AmbientCapabilities = [
      "CAP_NET_ADMIN"
      "CAP_NET_RAW"
    ];
    CapabilityBoundingSet = [
      "CAP_NET_ADMIN"
      "CAP_NET_RAW"
    ];
  };
}
