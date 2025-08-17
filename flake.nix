{
  description = "Francesco Bozzo's nix-darwin system flake configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix-Darwin
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
    inputs@{ self, ... }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MBP-M4-Pro
      darwinConfigurations."MBP-M4-Pro" = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          username = "fbozzo";
          hostname = "MBP-M4-Pro";
        };

        modules = [ ./hosts/macbook-pro ];
      };
    };
}
