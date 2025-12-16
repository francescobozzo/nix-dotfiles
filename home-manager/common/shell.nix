{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;

    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = false;
      plugins = [ ];
    };

    # profile zsh startup time
    # for i in $(seq 1 10); do time $SHELL -i -c exit; done
    zprof.enable = false;

    shellAliases = {
      ls = "eza"; # default view
      ll = "eza -bhl --group-directories-first"; # long list
      la = "eza -abhl --group-directories-first"; # all list
      lt = "eza --tree --level=2"; # tree
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

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };
}
