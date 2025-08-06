{ inputs, username,... }: {
  homebrew = {
    enable = true;

    global = {
      autoUpdate = true;
    };

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    masApps = {
      "Xcode" = 497799835;
      "WhatsApp Messenger" = 310633997;
      "Telegram Lite" = 946399090;
      "DAZN: Stream Live Sports" = 1129523589;
    };
  };

  nix-homebrew = {
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    # enableRosetta = true;

    user = "${username}";

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };

    # taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };
}
