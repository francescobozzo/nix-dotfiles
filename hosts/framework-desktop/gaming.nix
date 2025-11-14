{ pkgs, ... }:
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
  hardware.steam-hardware.enable = true;
  services.udev.packages = [
    pkgs.steam-devices-udev-rules
    pkgs.game-devices-udev-rules
  ];
}
