{
  description = "Francesco Bozzo's nix-darwin system flake configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Hardware
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Deployment
    deploy-rs.url = "github:serokell/deploy-rs";

    # Nix-Darwin
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Misc
    mac-app-util.url = "github:hraban/mac-app-util"; # Show MacOS applications in spotlight

    # vscode
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix4vscode.url = "github:nix-community/nix4vscode";
    nix4vscode.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew
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

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      flake = {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#MBP-M4-Pro
        darwinConfigurations."MBP-M4-Pro" = inputs.nix-darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
            username = "fbozzo";
            hostname = "MBP-M4-Pro";
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [ ./hosts/macbook-pro ];
        };

        nixosConfigurations.neos = inputs.nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            username = "fbozzo";
            hostname = "neos";
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
            ./hosts/framework-desktop
          ];
        };

        deploy.nodes.neos = {
          hostname = "neos";
          sshUser = "root";
          sudo = "doas -u";
          sshOpts = [ ];
          magicRollback = true;
          autoRollback = true;
          fastConnection = false;
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.neos;
          };
        };

        # This is highly advised, and will prevent many possible mistakes
        checks = builtins.mapAttrs (
          system: deployLib: deployLib.deployChecks self.deploy
        ) inputs.deploy-rs.lib;

      };
    };
}
