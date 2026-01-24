{ pkgs-unstable, system, ... }:
{
  imports = [
    (pkgs-unstable + /nixos/modules/services/misc/ollama.nix)
  ];
  nixpkgs.overlays = [
    (_: _: {
      inherit (pkgs-unstable.legacyPackages.${system}) ollama-rocm;
    })
  ];
  disabledModules = [
    "services/misc/ollama.nix"
  ];
}
