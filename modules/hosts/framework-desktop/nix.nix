{ inputs, ... }:
{
  flake.modules.nixos.fd = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.rocmSupport = true;
    nixpkgs.hostPlatform = "x86_64-linux";

    # It's sometimes helpful to tell Nixpkgs which GFX targets to compile ROCm for.
    # You can usually find this by running `rocminfo` or checking your GPU's specs.
    # nixpkgs.config.rocmTargets = [ "gfx1151" ]; # Add your GPU's GFX here

    nixpkgs.overlays = [
      (final: _prev: rec {
        unstable = import inputs.nixpkgs-unstable {
          system = final.stdenv.hostPlatform.system;
          config = final.config;
        };
        rocmPackages = unstable.rocmPackages;
      })
    ];

    # https://wiki.nixos.org/wiki/Zed#Nix-ld_(recommended)
    programs.nix-ld.enable = true;

    nix = {
      enable = true;
      settings = {
        experimental-features = "nix-command flakes";
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
          "https://cache.numtide.com"
          "https://nix-amd-ai.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          "nix-amd-ai.cachix.org-1:F4OU4vw/lV2oiG6SBHZ+nqjl4EFJuqI4X9A7pvaBmhQ="
        ];
      };
      optimise.automatic = true;

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 10d";
      };
    };

    system.stateVersion = "25.05";
  };
}
