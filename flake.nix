{
  description = "Francesco Bozzo's nix-darwin system flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
        url = "github:nix-community/home-manager/release-24.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    # show applications in spotlight
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, mac-app-util, nix-vscode-extensions, ... }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      security.pam.enableSudoTouchIdAuth = true;

      system.defaults = {
        dock = {
          autohide = true;
          show-recents = false;
        };
      };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
          pkgs.monitorcontrol
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

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
        home.stateVersion = "24.11";
        home.homeDirectory = "/Users/fbozzo";
        home.packages = with pkgs; [
          htop
          tree

          telegram-desktop
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
      ];
    };
  };
}
