{
  flake.modules.homeManager.ssh =
    { lib, pkgs, ... }:
    {
      programs.ssh = {
        enable = true;

        enableDefaultConfig = false;

        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            identityFile = "~/.ssh/id_ed25519";

            extraOptions = {
              AddKeysToAgent = "yes";
            }
            // lib.optionalAttrs pkgs.stdenv.isDarwin { UseKeychain = "yes"; };
          };

          "neos" = {
            extraOptions = {
              AddKeysToAgent = "yes";
              SetEnv = "TERM=xterm-256color";
            };
          };
        };
      };
    };
}
