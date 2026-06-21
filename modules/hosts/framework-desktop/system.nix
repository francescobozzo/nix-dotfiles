{ self, ... }:
{
  flake.modules.nixos.fd =
    { pkgs, lib, ... }:
    {
      programs.zsh.enable = true;
      programs.ssh.startAgent = true;

      environment.systemPackages = map lib.lowPrio [
        pkgs.curl
        pkgs.gitMinimal
        pkgs.amdgpu_top
        pkgs.tpm2-tss
        # pkgs.rocmPackages.amdsmi
        pkgs.rocmPackages.rocm-smi
        pkgs.rocmPackages.rocminfo
        pkgs.btop-rocm
        pkgs.ryzenadj
      ];

      imports = [
        self.modules.nixos.ai
        self.modules.nixos.ddns
        self.modules.nixos.gaming
        self.modules.nixos.glance
        self.modules.nixos.hass
        self.modules.nixos.immich
        self.modules.nixos.logrotate
        self.modules.nixos.monitoring
        self.modules.nixos.pihole
        self.modules.nixos.prometheus
        self.modules.nixos.restic
        self.modules.nixos.search
        self.modules.nixos.traefik
      ];

      time.timeZone = "Europe/Rome";
    };
}
