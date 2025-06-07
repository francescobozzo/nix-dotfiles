{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default.userSettings = {
        # This property will be used to generate settings.json:
        # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
        # "editor.formatOnSave" = true;
    };

    profiles.default.extensions = with pkgs.vscode-marketplace; [
      jnoortheen.nix-ide

      github.copilot
      github.copilot-chat
    ];
  };
}
