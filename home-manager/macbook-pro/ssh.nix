{
  programs.ssh = {
    enable = true;

    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "/Users/fbozzo/.ssh/id_ed25519";

        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };

      "neos" = {
        extraOptions = {
          SetEnv = "TERM=xterm-256color";
        };
      };
    };
  };
}
