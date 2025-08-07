
{ ... }: {
  # authentication
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;  # touchId in tmux

  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.24;
    autohide-time-modifier = 0.9;
    show-recents = false;
    tilesize = 64;
    persistent-apps = [
      "/Applications/WhatsApp.app"
      "/Applications/Telegram Lite.app"
      "/Users/fbozzo/Applications/Home Manager Apps/Spotify.app"
      "/Users/fbozzo/Applications/Home Manager Apps/Google Chrome.app"
      "/Applications/Xcode.app"
      "/Users/fbozzo/Applications/Home Manager Apps/Visual Studio Code.app"
      "/Applications/Ghostty.app"
    ];
    # Disable all hot corners
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
  };

  system.defaults.finder = {
    AppleShowAllFiles = true;
    ShowStatusBar = true;
    ShowPathbar = true;
    FXRemoveOldTrashItems = true;  # Remove items in the trash after 30 days
    FXPreferredViewStyle = "Nlsv"; # List view
    AppleShowAllExtensions = true;
    _FXShowPosixPathInTitle = true;
  };

  system.defaults.NSGlobalDomain = {
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = 1; # Use metric system
    AppleTemperatureUnit = "Celsius";
    AppleInterfaceStyle = "Dark";
  };

  power.sleep = {
    computer = 5; # minutes
    display = 3; # minutes
  };
}
