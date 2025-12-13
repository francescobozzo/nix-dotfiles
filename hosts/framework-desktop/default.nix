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
    ./boot.nix
    ./disks.nix
    ./gaming.nix
    ./hardware.nix
    ./llm.nix
    ./networking.nix
    ./services.nix
    ./users.nix
  ];

  nix = {
    enable = true;
    settings.experimental-features = "nix-command flakes";
    optimise.automatic = true;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
  };

  programs.zsh.enable = true;
  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.amdgpu_top
    # pkgs.rocmPackages.amdsmi
  ];

  time.timeZone = "Europe/Rome";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.hostPlatform = "x86_64-linux";
  nixpkgs.config.rocmSupport = true;

  system.stateVersion = "25.05";

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
