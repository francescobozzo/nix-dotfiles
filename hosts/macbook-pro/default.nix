{
  inputs,
  pkgs,
  pkgs-unstable,
  username,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ./brew.nix
    ./preferences.nix
  ];

  nix = {
    enable = true;
    settings.experimental-features = "nix-command flakes";
    optimise.automatic = true;

    # run on 0th day of every week
    gc.automatic = true;
    gc.interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    gc.options = "--delete-older-than 10d";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  system.primaryUser = username;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # apps
  nixpkgs.config.allowUnfree = true;
  environment = {
    systemPackages = [
      pkgs.vim
      pkgs.monitorcontrol
    ];
    variables = {
      "LESS" = "-R";
      "EDITOR" = "zeditor --wait";
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
    inputs.nix4vscode.overlays.forVscode
  ];

  services.tailscale.enable = true;

  # user
  programs.zsh.enable = true;
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    verbose = true;
    users.${username} = import ../../home-manager/macbook-pro;
    sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];
    extraSpecialArgs = {
      inherit username;
      inherit pkgs-unstable;
    };

    backupFileExtension = "backup";
  };
}
