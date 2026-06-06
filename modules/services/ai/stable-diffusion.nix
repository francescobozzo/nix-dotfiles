{ ... }:
{
  flake.modules.nixos.ai =
    { config, pkgs, ... }:
    let
      stable-diffusion =
        (pkgs.stable-diffusion-cpp.override {
          rocmSupport = true;
          rocmGpuTargets = [ "gfx1151" ];
          rocmPackages = pkgs.rocmPackages;
        }).overrideAttrs
          (oldAttrs: rec {
            version = "master-677-cfbc19d";

            src = pkgs.fetchFromGitHub {
              owner = "leejet";
              repo = "stable-diffusion.cpp";
              rev = version;
              hash = "sha256-Kt6GjJN1OdzzjZFb+L59m6JfU3n5Zz8oebZFqGaEhgU=";
              fetchSubmodules = true;
            };

          });
    in
    {
      environment.systemPackages = [
        stable-diffusion
      ];
    };
}
