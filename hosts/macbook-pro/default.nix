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
    shellAliases = {
      # https://github.com/ironicbadger/nix-config/blob/3aaa2cfb4dfa2299986ef5298b39286cc23c60f1/data/mac-dot-zshrc#L50
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
    inputs.nix4vscode.overlays.forVscode
  ];

  # Use Tailscale's App Store version to create a new network device with local dns override.
  # The open source one through nix pkgs requires a dns override, which could be implemented by
  # running networksetup -setdnsservers to all network devices (`networksetup -listallnetworkservices`):
  # - at `tailscale up` you should set the 100.100.100.100 Tailscale magic dns as the only resolver.
  # - at `tailscale down` you should set an empty resolver list to use the local network's DNS server.
  # References:
  # - https://tailscale.com/kb/1065/macos-variants
  # - https://github.com/nix-darwin/nix-darwin/blob/master/modules/networking/default.nix#L19
  # - https://github.com/nix-darwin/nix-darwin/blob/c31afa6e76da9bbc7c9295e39c7de9fca1071ea1/modules/services/tailscale.nix#L64
  services.tailscale = {
    enable = false;
    overrideLocalDns = false;
  };

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
