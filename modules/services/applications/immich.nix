{
  flake.modules.nixos.immich =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.immich = {
        enable = true;
        port = 2283;

        package = pkgs.unstable.immich;

        accelerationDevices = null;
        machine-learning.enable = true;

        settings = lib.mkIf config.fb.authelia.enable {
          passwordLogin.enabled = false;
          oauth = {
            enabled = true;
            issuerUrl = "https://auth.fbozzo.dpdns.org";
            clientId = "immich";
            clientSecret._secret = config.sops.secrets."immich/oidc-client-secret".path;
            scope = "openid profile email";
            tokenEndpointAuthMethod = "client_secret_basic";
            autoRegister = true;
            buttonText = "Sign in with Authelia";
          };
        };

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
          auth = lib.mkIf config.fb.authelia.enable {
            mode = "oidc";
            oidcClient = {
              client_id = "immich";
              client_name = "Immich";
              consent_mode = "implicit"; # for trusted services
              client_secret = ''{{ secret "${config.sops.secrets."immich/oidc-client-digest".path}" }}'';
              public = false;
              authorization_policy = "two_factor";
              require_pkce = true;
              pkce_challenge_method = "S256";
              redirect_uris = [
                "https://photos.fbozzo.dpdns.org/auth/login"
                "https://photos.fbozzo.dpdns.org/user-settings"
                "app.immich:///oauth-callback"
              ];
              scopes = [
                "openid"
                "profile"
                "email"
              ];
              response_types = [ "code" ];
              grant_types = [ "authorization_code" ];
              access_token_signed_response_alg = "none";
              userinfo_signed_response_alg = "none";
              token_endpoint_auth_method = "client_secret_basic";
            };
          };
          toBackup = [
            "${config.services.immich.mediaLocation}/backups"
            "${config.services.immich.mediaLocation}/library"
            "${config.services.immich.mediaLocation}/upload"
            "${config.services.immich.mediaLocation}/profile"
          ];
        }
      ];

      sops.secrets = lib.mkIf config.fb.authelia.enable {
        "immich/oidc-client-secret".restartUnits = [ "immich-server.service" ];
        "immich/oidc-client-digest" = {
          owner = "authelia-main";
          restartUnits = [ "authelia-main.service" ];
        };
      };

      users.users.immich.extraGroups = [
        "video"
        "render"
      ];
    };
}
