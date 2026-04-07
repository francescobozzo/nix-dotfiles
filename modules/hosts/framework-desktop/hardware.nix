{
  flake.modules.nixos.fd =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      # Firmware updater
      services.fwupd.enable = true;

      systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];

      hardware = {
        graphics.enable = true;
        amdgpu.initrd.enable = true;
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings = {
            General = {
              Experimental = true;
              Privacy = "device";
              JustWorksRepairing = "always";
              Class = "0x000100";
              FastConnectable = true;
            };
          };
        };
      };
    };
}
