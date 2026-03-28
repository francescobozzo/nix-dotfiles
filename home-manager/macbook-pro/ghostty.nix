{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;

    settings = {
      auto-update = "off";
      mouse-hide-while-typing = true;
      font-size = 16;
      theme = "catppuccin-macchiato";
      window-width = 100;
      window-height = 27;
      quick-terminal-position = "top";
      quick-terminal-screen = "main";
      quick-terminal-space-behavior = "remain";
      quick-terminal-animation-duration = 0;

      keybind = [
        "global:super+period=toggle_quick_terminal"
        "ctrl+k=clear_screen"
        "cmd+alt+h=resize_split:left,10"
        "cmd+alt+j=resize_split:down,10"
        "cmd+alt+k=resize_split:up,10"
        "cmd+alt+l=resize_split:right,10"
        "cmd+h=goto_split:left"
        "cmd+j=goto_split:down"
        "cmd+k=goto_split:up"
        "cmd+l=goto_split:right"
      ];
    };

    themes = {
      catppuccin-macchiato = {
        palette = [
          "0=#494d64"
          "1=#ed8796"
          "2=#a6da95"
          "3=#eed49f"
          "4=#8aadf4"
          "5=#f5bde6"
          "6=#8bd5ca"
          "7=#a5adcb"
          "8=#5b6078"
          "9=#ed8796"
          "10=#a6da95"
          "11=#eed49f"
          "12=#8aadf4"
          "13=#f5bde6"
          "14=#8bd5ca"
          "15=#b8c0e0"
        ];
        background = "24273a";
        foreground = "cad3f5";
        cursor-color = "f4dbd6";
        cursor-text = "24273a";
        selection-background = "3a3e53";
        selection-foreground = "cad3f5";
      };
    };
  };
}
