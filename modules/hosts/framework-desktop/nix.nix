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
      (final: _prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.stdenv.hostPlatform.system;
          config = final.config;
        };
      })
    ];

    nix = {
      enable = true;
      settings = {
        experimental-features = "nix-command flakes";
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
