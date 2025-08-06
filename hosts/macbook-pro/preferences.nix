
{ ... }: {
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.24;
      autohide-time-modifier = 0.9;
      show-recents = false;
      persistent-apps = [
        "/Applications/WhatsApp.app"
        "/Applications/Telegram Lite.app"
        "/Users/fbozzo/Applications/Home Manager Apps/Spotify.app"
        "/Users/fbozzo/Applications/Home Manager Apps/Google Chrome.app"
        "/Applications/Xcode.app"
        "/Users/fbozzo/Applications/Home Manager Apps/Visual Studio Code.app"
      ];
    };
    finder = {
      AppleShowAllFiles = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      FXRemoveOldTrashItems = true;  # Remove items in the trash after 30 days
      FXPreferredViewStyle = "Nlsv"; # List view
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
    };
  };
}
