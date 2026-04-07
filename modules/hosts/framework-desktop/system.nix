{ self, ... }:
{
  flake.modules.nixos.fd =
    { pkgs, lib, ... }:
    {
      programs.zsh.enable = true;
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
        self.modules.nixos.ddns
        self.modules.nixos.gaming
        self.modules.nixos.glance
        self.modules.nixos.hass
        self.modules.nixos.immich
        self.modules.nixos.llm
        self.modules.nixos.logrotate
        self.modules.nixos.neo4j
        self.modules.nixos.pihole
        self.modules.nixos.prometheus
        self.modules.nixos.restic
        self.modules.nixos.traefik
        self.modules.nixos.uptime-kuma
      ];

      time.timeZone = "Europe/Rome";
    };
}
