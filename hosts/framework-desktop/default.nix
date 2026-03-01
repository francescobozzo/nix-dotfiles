{
  inputs,
  modulesPath,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./system/backup.nix
    ./system/boot.nix
    ./system/desktop.nix
    ./system/disks.nix
    ./system/hardware.nix
    ./system/networking.nix
    ./system/nix.nix
    ./system/sops.nix
    ./system/users.nix
    ./system/virtualisation.nix

    ./services/ddns.nix
    ./services/gaming.nix
    ./services/glance.nix
    ./services/hass.nix
    ./services/llm.nix
    ./services/logrotate.nix
    ./services/neo4j.nix
    ./services/pihole.nix
    ./services/prometheus.nix
    ./services/traefik.nix
    ./services/uptime-kuma.nix
  ];

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
  ];

  time.timeZone = "Europe/Rome";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../home-manager/framework-desktop;
    extraSpecialArgs = {
      inherit username;
    };

    backupFileExtension = "backup";
  };
}
