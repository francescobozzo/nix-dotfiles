{
  inputs,
  config,
  username,
  ...
}:
{
  homebrew = {
    enable = true;

    global.autoUpdate = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    casks = [
      "ghostty" # currently home manager doesn't support ghostty on nix darwin
      "nvidia-geforce-now"
    ];

    masApps = {
      "Xcode" = 497799835;
      "WhatsApp Messenger" = 310633997;
      "Telegram Lite" = 946399090;
      # "DAZN: Diretta Calcio e Sport" = 1129523589;
    };

    # Needed to resolve the "Refusing to untap homebrew/cask" error
    # https://github.com/zhaofengli/nix-homebrew/issues/5#issuecomment-1878798641
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  nix-homebrew = {
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    user = username;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };

    # taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };
}
