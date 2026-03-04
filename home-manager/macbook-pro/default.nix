{
  pkgs,
  pkgs-unstable,
  username,
  ...
}:
{
  imports = [
    ../common/dev.nix
    ../common/git.nix
    ../common/shell.nix
    ./vscode
    ./claude.nix
    ./ghostty.nix
    ./opencode.nix
    ./ssh.nix
    ./zed.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # stateVersion is best to remain set to the version you first installed Home Manager.
  # it ensures backward compatibility and prevents breaking changes from affecting your
  # existing configuration.
  home.stateVersion = "25.05";
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    pkgs-unstable.google-chrome
    obsidian

    # llm
    pkgs-unstable.gemini-cli
    pkgs-unstable.antigravity

    # utilities
    bat
    less
    htop
    mactop
    tree
    ripgrep

    # containers
    colima
    docker

    # nix
    nixfmt
    nil

    # reverse engineering
    # desmume
    melonDS
    ndstool
    imhex
    ghidra
    gcc-arm-embedded

    # os
    nixos-anywhere
    deploy-rs
    mkpasswd
    age
  ];

  # just to install kitten since it used by Ghostty to display images with fzf preview
  # https://github.com/junegunn/fzf/blob/master/bin/fzf-preview.sh#L68
  programs.kitty = {
    enable = true;
  };

  # link additional dotfiles that are not handled by home manager
  home.file.".config" = {
    source = ../../config;
    recursive = true;
  };
}
