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
            version = "master-778-c00a9e9";

            src = pkgs.fetchFromGitHub {
              owner = "leejet";
              repo = "stable-diffusion.cpp";
              rev = version;
              hash = "sha256-XNZkmdr6PB+0Bb22/m75yXS9r7PijyYORBoDxtcf/QQ=";
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
