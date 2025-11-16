{ pkgs, config, ... }:
{
  # https://wiki.nixos.org/wiki/Steam
  programs.steam = {
    enable = true;
    extest.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  services.udev.packages = [
    pkgs.steam-devices-udev-rules
    pkgs.game-devices-udev-rules
  ];

  hardware = {
    steam-hardware.enable = true;
    xpadneo.enable = true; # xbox controller
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    xpadneo
  ];
}
