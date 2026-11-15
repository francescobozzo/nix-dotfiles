{
  flake.modules.nixos.trilium =
    { config, pkgs, lib, ... }:
    {
      services.trilium-server = {
        enable = true;
        port = 12783;
        package = pkgs.unstable.trilium-server;
        noAuthentication = false;
        environmentFile = lib.mkIf config.fb.authelia.enable config.sops.templates."trilium-oidc.env".path;
      };

      fb.services = [
        {
          name = "trilium";
          subdomain = "notes";
          port = config.services.trilium-server.port;
          category = "misc";
          icon = "di:trilium";
          auth = lib.mkIf config.fb.authelia.enable {
            mode = "oidc";
            oidcClient = {
              client_id = "trilium";
              client_name = "Trilium";
              consent_mode = "implicit";
              client_secret = ''{{ secret "${config.sops.secrets."trilium/oidc-client-digest".path}" }}'';
              public = false;
              authorization_policy = "two_factor";
              redirect_uris = [ "https://notes.fbozzo.dpdns.org/callback" ];
              scopes = [ "openid" "profile" "email" ];
              response_types = [ "code" ];
              grant_types = [ "authorization_code" ];
              token_endpoint_auth_method = "client_secret_basic";
            };
          };
          toBackup = [
            config.services.trilium-server.dataDir
          ];
          gatusHealthcheckEndpoint = "/api/health-check";
          extraGatusConditions = [
            "[BODY].status == ok"
          ];
        }
      ];

      sops = lib.mkIf config.fb.authelia.enable {
        secrets = {
          "trilium/oidc-client-secret" = { };
          "trilium/oidc-client-digest" = {
            owner = "authelia-main";
            restartUnits = [ "authelia-main.service" ];
          };
        };
        templates."trilium-oidc.env" = {
          restartUnits = [ "trilium-server.service" ];
          content = ''
            TRILIUM_MULTIFACTORAUTHENTICATION_OAUTHBASEURL=https://notes.fbozzo.dpdns.org
            TRILIUM_MULTIFACTORAUTHENTICATION_OAUTHCLIENTID=trilium
            TRILIUM_MULTIFACTORAUTHENTICATION_OAUTHCLIENTSECRET=${config.sops.placeholder."trilium/oidc-client-secret"}
            TRILIUM_MULTIFACTORAUTHENTICATION_OAUTHISSUERBASEURL=https://auth.fbozzo.dpdns.org
            TRILIUM_MULTIFACTORAUTHENTICATION_OAUTHISSUERNAME=Authelia
          '';
        };
      };
    };
}
