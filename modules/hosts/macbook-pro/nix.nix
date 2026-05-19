{ inputs, ... }:
{
  flake.modules.darwin.macbook-pro = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = "aarch64-darwin";

    nixpkgs.overlays = [
      (final: _prev: {
        unstable = import inputs.nixpkgs-darwin-unstable {
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
          "https://cache.numtide.com"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };
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
  };
}
