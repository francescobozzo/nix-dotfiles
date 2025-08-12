{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ ];
    };
  };
}
