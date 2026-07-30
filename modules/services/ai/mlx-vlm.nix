{ ... }:
{
  flake.modules.darwin.ai =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs.unstable.python314Packages; [
        mlx-vlm
        mlx-lm
        huggingface-hub
      ];
    };
}
