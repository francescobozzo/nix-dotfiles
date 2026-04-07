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
  };
}
