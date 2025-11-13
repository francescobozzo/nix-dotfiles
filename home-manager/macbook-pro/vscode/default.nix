{
  programs.vscode.enable = true;
  programs.vscode.mutableExtensionsDir = true;

  imports = [
    ./extensions.nix
    ./settings.nix
  ];
}
