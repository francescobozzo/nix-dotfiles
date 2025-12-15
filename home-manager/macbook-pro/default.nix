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
    ./ssh.nix
    ./vscode
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
    google-chrome
    obsidian

    # llm
    # https://github.com/sst/opencode/issues/1890
    # https://github.com/ggml-org/llama.cpp/pull/16755
    pkgs-unstable.opencode
    pkgs-unstable.gemini-cli

    # utilities
    bat
    htop
    tree
    ripgrep

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
