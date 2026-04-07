{ self, ... }:
{
  flake.modules.darwin.macbook-pro =
    { pkgs, ... }:
    let
      username = "fbozzo";
    in
    {
      system.primaryUser = username;
      home-manager.users.${username} = {
        imports = [
          self.modules.homeManager.dev
          self.modules.homeManager.ai-agents
          self.modules.homeManager.reverse-engineering
          self.modules.homeManager.shell
          self.modules.homeManager.ssh
        ];

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        # stateVersion is best to remain set to the version you first installed Home Manager.
        # it ensures backward compatibility and prevents breaking changes from affecting your
        # existing configuration.
        home.stateVersion = "25.05";
        home.homeDirectory = "/Users/${username}";

        home.packages = with pkgs; [
          unstable.google-chrome
          obsidian
          rapidraw

          # containers
          colima
          docker

          # os
          nixos-anywhere
          deploy-rs
          mkpasswd
          age
        ];
      };
    };
}
