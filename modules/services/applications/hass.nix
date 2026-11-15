{
  flake.modules.nixos.hass =
    {
      config,
      pkgs,
      lib,
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
        customComponents =
          with pkgs.home-assistant-custom-components;
          [
            smartir
          ]
          ++ lib.optional config.fb.authelia.enable pkgs.home-assistant-custom-components.auth_oidc;

        config = {
          default_config = { };

          auth_oidc = lib.mkIf config.fb.authelia.enable {
            client_id = "home-assistant";
            discovery_url = "https://auth.fbozzo.dpdns.org/.well-known/openid-configuration";
            display_name = "Authelia";
            # Enter Companion app login codes at https://hass.fbozzo.dpdns.org/auth/oidc/welcome
            # Enable temporarily to link existing users on their first OIDC login.
            # features.automatic_user_linking = true;
          };

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
            auth_providers = lib.mkIf config.fb.authelia.enable [ ];
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

      fb.services = [
        {
          name = "hass";
          port = config.services.home-assistant.config.http.server_port;
          category = "misc";
          icon = "di:home-assistant";
          auth = lib.mkIf config.fb.authelia.enable {
            mode = "oidc";
            oidcClient = {
              client_id = "home-assistant";
              client_name = "Home Assistant";
              consent_mode = "implicit";
              public = true;
              authorization_policy = "two_factor";
              require_pkce = true;
              pkce_challenge_method = "S256";
              redirect_uris = [ "https://hass.fbozzo.dpdns.org/auth/oidc/callback" ];
              scopes = [
                "openid"
                "profile"
                "groups"
              ];
              response_types = [ "code" ];
              grant_types = [ "authorization_code" ];
              access_token_signed_response_alg = "none";
              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "none";
            };
          };
          toBackup = [
            config.services.home-assistant.configDir
          ];
        }
      ];
    };
}
