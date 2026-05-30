{
  flake.modules.homeManager.reverse-engineering =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # desmume
        melonds
        ndstool
        imhex
        ghidra
      ];
    };
}
