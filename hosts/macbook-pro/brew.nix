{ inputs, username,... }:

let
  taps = {
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
  };
in
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
      "ghostty"  # currently home manager doesn't support ghostty on nix darwin
    ];

    masApps = {
      "Xcode" = 497799835;
      "WhatsApp Messenger" = 310633997;
      "Telegram Lite" = 946399090;
      "DAZN: Stream Live Sports" = 1129523589;
    };

    # Needed to resolve the "Refusing to untap homebrew/cask" error
    # https://github.com/zhaofengli/nix-homebrew/issues/5#issuecomment-1878798641
    taps = builtins.attrNames taps;
  };

  nix-homebrew = {
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    # enableRosetta = true;

    user = username;
    inherit taps;

    # taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };
}
