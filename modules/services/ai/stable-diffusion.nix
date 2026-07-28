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
            version = "master-797-5ef4a75";

            src = pkgs.fetchFromGitHub {
              owner = "leejet";
              repo = "stable-diffusion.cpp";
              rev = version;
              hash = "sha256-Bfft6ZqEK1+U6SoEZNKorPDNVDQNPQnt7kb+hQj6qbQ=";
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
