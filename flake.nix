{
  description = "Francesco Bozzo's nix-darwin system flake configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Hardware
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Deployment
    deploy-rs.url = "github:serokell/deploy-rs";

    # Nix-Darwin
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nixpkgs-darwin-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Misc
    mac-app-util.url = "github:hraban/mac-app-util"; # Show MacOS applications in spotlight
    llm-agents.url = "github:numtide/llm-agents.nix";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";
    ds4.url = "github:fedeizzo/ds4";

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
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];
    };
}
