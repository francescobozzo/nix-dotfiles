{
  services = {
    # KDE Plasma
    xserver.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;

    # Firmware updater
    fwupd.enable = true;

    # AMD GPU driver
    xserver.videoDrivers = [ "amdgpu" ];
  };
}
