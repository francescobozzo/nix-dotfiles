{ self, ... }:
{
  flake.modules.nixos.fd =
    { pkgs, ... }:
    let
      username = "fbozzo";
    in
    {
      home-manager.users.${username} = {
        imports = [
          self.modules.homeManager.dev
          self.modules.homeManager.shell
        ];

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        # stateVersion is best to remain set to the version you first installed Home Manager.
        # it ensures backward compatibility and prevents breaking changes from affecting your
        # existing configuration.
        home.stateVersion = "25.05";
        home.homeDirectory = "/home/${username}";

        home.packages = with pkgs; [
          google-chrome
        ];
      };

      users.mutableUsers = false;
      users.users = {
        ${username} = {
          name = username;
          isNormalUser = true;
          createHome = true;
          extraGroups = [
            "wheel"
            "networkmanager"
            "docker"
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
    };
}
