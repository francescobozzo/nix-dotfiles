{ pkgs, username, ... }:
{
  imports = [
    ../common/dev.nix
    ../common/git.nix
    ../common/shell.nix
    # ./ssh.nix
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

    # utilities
    bat
    htop
    tree
    ripgrep
    jq
  ];
}
