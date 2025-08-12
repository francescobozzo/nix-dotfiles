{
  programs.vscode.profiles.default.userSettings = {
    # This property will be used to generate settings.json:
    # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson

    "extensions.autoCheckUpdates" = false;
    "extensions.ignoreRecommendations" = true;
    "update.mode" = "none";

    "workbench.iconTheme" = "vscode-icons";
    "vsicons.dontShowNewVersionMessage" = true;

    "telemetry.enableCrashReporter" = false;
    "telemetry.enableTelemetry" = false;
    "telemetry.telemetryLevel" = "off";

    "editor.formatOnSave" = true;

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

    # enable delta to open files from hyperlinks
    "security.promptForLocalFileProtocolHandling" = false;
  };
}
