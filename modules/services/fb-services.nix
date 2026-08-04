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
    in
    {
      options.fb = {
        services = mkOption {
          type = types.listOf serviceModule;
        };
      };
    };
}
