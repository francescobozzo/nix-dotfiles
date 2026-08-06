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
            extraGatusConditions = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            toBackup = mkOption {
              type = types.listOf types.str;
              default = [ ];
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
