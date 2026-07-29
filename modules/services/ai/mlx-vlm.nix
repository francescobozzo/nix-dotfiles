{ ... }:
{
  flake.modules.darwin.ai =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.unstable.python314Packages.mlx-vlm
      ];
    };
}
