{
  flake.modules.nixos.authelia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.fb.authelia;
      secret = name: config.sops.secrets."authelia/${name}".path;
      clients = map (service: service.auth.oidcClient) (
        builtins.filter (service: service.auth.mode == "oidc") config.fb.services
      );
      autheliaSecrets = [
        "jwt"
        "storage-key"
        "oidc-hmac"
        "oidc-key"
        "users"
        "smtp-config"
      ];
    in
    {
      options.fb.authelia = {
        enable = lib.mkEnableOption "Authelia single sign-on";
        port = lib.mkOption {
          type = lib.types.port;
          default = 9091;
          description = "Local port on which Authelia listens.";
        };
      };

      config = lib.mkIf cfg.enable {
        sops.secrets = lib.genAttrs (map (name: "authelia/${name}") autheliaSecrets) (_: {
          owner = "authelia-main";
          restartUnits = [ "authelia-main.service" ];
        });

        services.authelia.instances.main = {
          enable = true;
          secrets = {
            jwtSecretFile = secret "jwt";
            storageEncryptionKeyFile = secret "storage-key";
            oidcHmacSecretFile = secret "oidc-hmac";
            oidcIssuerPrivateKeyFile = secret "oidc-key";
          };
          # Restore this after SMTP2GO delivery is fixed, and remove notifier.filesystem.
          # settingsFiles = [ (secret "smtp-config") ];
          settings = {
            server.address = "tcp://127.0.0.1:${toString cfg.port}/";
            log.level = "info";
            default_2fa_method = "totp";
            notifier.filesystem.filename = "/var/lib/authelia-main/notifications.txt";
            authentication_backend.file.path = "/var/lib/authelia-main/users.yml";
            access_control = {
              default_policy = "deny";
              rules =
                map (service: {
                  domain = "${service.subdomain}.fbozzo.dpdns.org";
                  policy = "two_factor";
                }) (builtins.filter (service: service.auth.mode == "forwardAuth") config.fb.services)
                ++ [
                  {
                    domain = "*.fbozzo.dpdns.org";
                    policy = "deny";
                  }
                ];
            };
            session.cookies = [
              {
                domain = "fbozzo.dpdns.org";
                authelia_url = "https://auth.fbozzo.dpdns.org";
              }
            ];
            storage.local.path = "/var/lib/authelia-main/db.sqlite3";
            identity_providers.oidc.clients = clients;
          };
        };

        # Seed once: Authelia may subsequently update this file for password resets.
        systemd.services.authelia-main.preStart = lib.mkBefore ''
          if [ ! -e /var/lib/authelia-main/users.yml ]; then
            install -m 0600 ${secret "users"} /var/lib/authelia-main/users.yml
          fi
        '';

        fb.services = [
          {
            name = "authelia";
            subdomain = "auth";
            port = cfg.port;
            category = "infrastructure";
            icon = "di:authelia";
            gatusHealthcheckEndpoint = "/api/health";
            toBackup = [
              "/var/lib/authelia-main/users.yml"
              "/var/lib/authelia-backup/db.sqlite3"
            ];
            backupPrepareCommand = ''
              mkdir -p -m 0700 /var/lib/authelia-backup
              ${lib.getExe pkgs.sqlite} /var/lib/authelia-main/db.sqlite3 '.backup /var/lib/authelia-backup/db.sqlite3'
              chmod 0600 /var/lib/authelia-backup/db.sqlite3
            '';
          }
        ];

      };
    };
}

