{ inputs, pkgs, username, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ./brew.nix
    ./preferences.nix
  ];

  # nix
  nix = {
    enable = true;
    settings.experimental-features = "nix-command flakes";
    optimise.automatic = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  system.primaryUser = username;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  security.pam.services.sudo_local.touchIdAuth = true;

  # apps
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.vim
    pkgs.monitorcontrol
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

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
    users.${username} = import ../../home-manager;
    sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];
    extraSpecialArgs = {
      inherit username;
    };
  };
}
