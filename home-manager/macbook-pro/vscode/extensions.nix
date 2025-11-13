{ pkgs, ... }:
{
  programs.vscode.profiles.default.extensions = pkgs.nix4vscode.forVscode [
    "jnoortheen.nix-ide"

    # Themes
    "vscode-icons-team.vscode-icons"

    # AI
    "github.copilot"
    "github.copilot-chat"

    # Python
    "ms-python.python"
    "charliermarsh.ruff"

    # Rust
    "rust-lang.rust-analyzer"
  ];
}
