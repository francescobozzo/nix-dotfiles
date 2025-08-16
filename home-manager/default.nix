{ pkgs, username, ... }:
{
  imports = [
    ./vscode
    ./dev.nix
    ./git.nix
    ./ssh.nix
    ./shell.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # stateVersion is best to remain set to the version you first installed Home Manager.
  # it ensures backward compatibility and prevents breaking changes from affecting your
  # existing configuration.
  home.stateVersion = "25.05";
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    # utilities
    bat
    htop
    tree
    ripgrep

    # nix
    nixfmt-rfc-style
    nil

    google-chrome
    spotify
  ];

  # link additional dotfiles that are not handled by home manager
  home.file.".config" = {
    source = ../config;
    recursive = true;
  };
}
