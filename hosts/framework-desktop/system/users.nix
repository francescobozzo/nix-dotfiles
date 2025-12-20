{ pkgs, username, ... }:
{
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
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNF1yDeweP0dS1VdongvQqcnwfqnRm/iV9rr0EVk2t/ francesco.bozzo.99@gmail.com"
      ];
    };

    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNF1yDeweP0dS1VdongvQqcnwfqnRm/iV9rr0EVk2t/ francesco.bozzo.99@gmail.com"
      ];
      hashedPassword = "$6$w6UYvw/qfQjnZn4s$X4JoDYFZZmCmMdq4LUcxflRhK98KuVs3DerIA4aaUb1pQVE9jxKAnC8ptIjgc7oKU1Qg0xRGkz2/V1QFg.zb9/";
    };
  };
}
