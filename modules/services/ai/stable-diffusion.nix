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
            version = "master-1091-b9d7176";

            src = pkgs.fetchFromGitHub {
              owner = "leejet";
              repo = "stable-diffusion.cpp";
              rev = version;
              hash = "sha256-CMl58h02i9qeZLvnP8hJOns+yIQWwVNm5Eo6YdIBtq4=";
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
