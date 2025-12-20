{
  programs.vscode.enable = true;
  programs.vscode.mutableExtensionsDir = true;

  imports = [
    # ./extensions.nix # TODO: fix broken build
    ./settings.nix
  ];
}
