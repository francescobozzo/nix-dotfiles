{
  flake.modules.nixos.hass =
    { config, pkgs, ... }:
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
          "xiaomi_ble" # framework desktop's bluetooth module
          "switchbot"
          "broadlink" # infrared remote

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
        customComponents = with pkgs.home-assistant-custom-components; [
          smartir
        ];

        config = {
          default_config = { };

          smartir.check_updates = false;
          climate = [
            {
              # https://github.com/smartHomeHub/SmartIR/blob/master/docs/CLIMATE.md
              platform = "smartir";
              name = "Daikin Living";
              unique_id = "living_ac";
              device_code = 1106; # 1118
              controller_data = "remote.remote_broadlink";
              # temperature_sensor: sensor.temperature
              # humidity_sensor: sensor.humidity
              # power_sensor: binary_sensor.ac_power
            }
          ];

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
          lovelace.resource_mode = "yaml";
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
    };
}
