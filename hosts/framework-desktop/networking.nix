{ hostname, lib, ... }:
{
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
  };

  services.tailscale.enable = true;

  # networking.interfaces.enp191s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp192s0.useDHCP = lib.mkDefault true;
}
