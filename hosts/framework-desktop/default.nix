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
    ./disks.nix
    ./hardware-configuration.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.htop
  ];

  time.timeZone = "Europe/Rome";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.hostPlatform = "x86_64-linux";

  users.mutableUsers = false;
  users.users = {
    ${username} = {
      name = username;
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
      hashedPassword = "$6$w6UYvw/qfQjnZn4s$X4JoDYFZZmCmMdq4LUcxflRhK98KuVs3DerIA4aaUb1pQVE9jxKAnC8ptIjgc7oKU1Qg0xRGkz2/V1QFg.zb9/";
    };

    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNF1yDeweP0dS1VdongvQqcnwfqnRm/iV9rr0EVk2t/ francesco.bozzo.99@gmail.com"
    ];
    root.hashedPassword = "$6$w6UYvw/qfQjnZn4s$X4JoDYFZZmCmMdq4LUcxflRhK98KuVs3DerIA4aaUb1pQVE9jxKAnC8ptIjgc7oKU1Qg0xRGkz2/V1QFg.zb9/";
  };
  system.stateVersion = "25.05";
}
