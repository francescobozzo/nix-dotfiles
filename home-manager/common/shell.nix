{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;

    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      package.disabled = true;
    };
  };

  programs.fzf = {
    enable = true;
    package = pkgs.fzf.overrideAttrs (oldAttrs: {
      postInstall = oldAttrs.postInstall + ''
        install bin/fzf-preview.sh $out/bin
      '';
    });
    enableZshIntegration = true;
    fileWidgetOptions = [ "--preview 'fzf-preview.sh {}'" ];
  };
}
