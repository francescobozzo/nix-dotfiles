{
  description = "Francesco Bozzo's nix-darwin system flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
        url = "github:nix-community/home-manager/release-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    # show applications in spotlight
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, mac-app-util, nix-vscode-extensions, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      security.pam.services.sudo_local.touchIdAuth = true;

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

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
          pkgs.monitorcontrol
        ];

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
          Xcode = 497799835;
          "WhatsApp Messenger" = 310633997;
          "Telegram Lite" = 946399090;
          "DAZN: Stream Live Sports" = 1129523589;
        };
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      system.primaryUser = "fbozzo";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      nixpkgs.overlays = [
        nix-vscode-extensions.overlays.default
      ];
    };
    homeconfig = {pkgs, ...}: {
        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        # this is internal compatibility configuration 
        # for home-manager, don't change this!
        home.stateVersion = "25.05";
        home.homeDirectory = "/Users/fbozzo";
        home.packages = with pkgs; [
          htop
          tree

          google-chrome
          spotify
        ];

        imports = [
          ./home/git
          ./home/ssh
          ./home/vscode
        ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MBP-M4-Pro
    darwinConfigurations."MBP-M4-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          users.users.fbozzo.home = "/Users/fbozzo";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.fbozzo = homeconfig;

          home-manager.sharedModules = [
            mac-app-util.homeManagerModules.default
          ];
        }

        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            # enableRosetta = true;

            user = "fbozzo";

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];
    };
  };
}
