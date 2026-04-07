{
  flake.modules.homeManager.reverse-engineering =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # desmume
        melonDS
        ndstool
        imhex
        ghidra
        gcc-arm-embedded
      ];
    };
}
