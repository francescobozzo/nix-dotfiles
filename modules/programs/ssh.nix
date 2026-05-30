{
  flake.modules.homeManager.ssh =
    { lib, pkgs, ... }:
    {
      programs.ssh = {
        enable = true;

        enableDefaultConfig = false;

        settings = {
          "github.com" = {
            HostName = "github.com";
            IdentityFile = "~/.ssh/id_ed25519";
            AddKeysToAgent = "yes";
          }
          // lib.optionalAttrs pkgs.stdenv.isDarwin { UseKeychain = "yes"; };

          "neos" = {
            AddKeysToAgent = "yes";
            SetEnv = {
              TERM = "xterm-256color";
            };
          };
        };
      };
    };
}
