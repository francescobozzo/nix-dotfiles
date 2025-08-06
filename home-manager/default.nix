{ pkgs, username, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./vscode.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # this is internal compatibility configuration 
  # for home-manager, don't change this!

  home = {
    inherit username;
    stateVersion = "25.05";
    homeDirectory = "/Users/${username}";
  };

  home.packages = with pkgs; [
    htop
    tree

    google-chrome
    spotify
  ];
}
