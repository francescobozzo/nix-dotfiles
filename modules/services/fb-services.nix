{
  flake.modules.nixos.fb-services =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    with lib;
    let
      serviceModule = types.submodule (
        { config, ... }: {
          options = {
            name = mkOption { type = types.str; };
            subdomain = mkOption {
              type = types.nullOr types.str;
              default = config.name;
            };
            port = mkOption { type = types.int; };
            gatusHealthcheckEndpoint = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            category = mkOption {
              type = (
                types.enum [
                  "ai"
                  "media"
                  "infrastructure"
                  "observability"
                  "misc"
                ]
              );
            };
            icon = mkOption { type = types.str; };
            auth = {
              mode = mkOption {
                type = types.enum [
                  "none"
                  "oidc"
                  "forwardAuth"
                ];
                default = "none";
              };
              oidcClient = mkOption {
                type = types.nullOr (pkgs.formats.yaml { }).type;
                default = null;
                description = "Authelia OIDC client configuration, owned by the service.";
              };
              forwardAuthHeaders = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Identity response headers to copy from Authelia to this service.";
              };
            };
            extraGatusConditions = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            toBackup = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            backupPrepareCommand = mkOption {
              type = types.lines;
              default = "";
              description = "Commands to prepare this service's files before the shared backup.";
            };
          };
        }
      );

      # distinct values that appear more than once, in first-occurrence order
      dupes = xs: unique (filter (x: count (y: y == x) xs > 1) xs);

      services = config.fb.services;
      dupeNames = dupes (map (s: s.name) services);
      dupeSubdomains = dupes (map (s: s.subdomain) services);
      dupePorts = dupes (map (s: s.port) services);
    in
    {
      options.fb = {
        services = mkOption {
          type = types.listOf serviceModule;
        };
      };

      config.assertions = [
        {
          assertion = all (s: (s.auth.mode == "oidc") == (s.auth.oidcClient != null)) services;
          message = "An fb.services OIDC client must be supplied exactly when auth.mode is oidc.";
        }
        {
          assertion = all (s: s.auth.mode == "forwardAuth" || s.auth.forwardAuthHeaders == [ ]) services;
          message = "fb.services forwardAuthHeaders require forwardAuth mode.";
        }
        {
          assertion = config.fb.authelia.enable || all (s: s.auth.mode == "none") services;
          message = "Authenticated fb.services require fb.authelia.enable.";
        }
        {
          assertion = dupeNames == [ ];
          message = "fb.services names must be unique; duplicates: ${toString dupeNames}";
        }
        {
          assertion = dupeSubdomains == [ ];
          message = "fb.services subdomains must be unique; duplicates: ${toString dupeSubdomains}";
        }
        {
          assertion = dupePorts == [ ];
          message = "fb.services ports must be unique; duplicates: ${toString dupePorts}";
        }
      ];
    };
}
