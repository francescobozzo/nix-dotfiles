{
  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # kernel
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usbhid"
      "uas"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelParams = [
      "nohibernate"
      "amdgpu.gttsize=131072" # Enables unified GPU/system memory (128 GiB)
      "ttm.pages_limit=33554432" # Allows large pinned memory allocations (128 GiB)
      "amd_iommu=off" # Disables IOMMU for lower latency
    ];
  };
}
