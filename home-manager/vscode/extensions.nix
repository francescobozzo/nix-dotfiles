{ pkgs, ... }:
{
  programs.vscode.profiles.default.extensions = with pkgs.vscode-marketplace; [
    jnoortheen.nix-ide

    # Themes
    vscode-icons-team.vscode-icons

    # AI
    github.copilot
    github.copilot-chat

    # Python
    ms-python.python
    charliermarsh.ruff
  ];
}
