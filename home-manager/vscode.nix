{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    mutableExtensionsDir = true;

    profiles.default.userSettings = {
      # This property will be used to generate settings.json:
      # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
      "editor.formatOnSave" = true;

      "workbench.iconTheme" = "vscode-icons";
      "vsicons.dontShowNewVersionMessage" = true;

      # Nix
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "nixfmt";
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };

      # Python
      "[python]" = {
        "editor.codeActionsOnSave" = {
          # "source.fixAll" = "explicit";
          "source.organizeImports" = "explicit";
        };
        "editor.defaultFormatter" = "charliermarsh.ruff";
      };

      # Jupyter Notebook settings
      "notebook.formatOnSave.enabled" = true;
      "notebook.codeActionsOnSave" = {
        # "notebook.source.fixAll" = "explicit";
        "notebook.source.organizeImports" = "explicit";
      };

      "github.copilot.enable" = {
        "*" = true;
        "plaintext" = false;
        "markdown" = false;
        "nix" = false;
      };
    };

    profiles.default.extensions = with pkgs.vscode-marketplace; [
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
  };
}
