{
  programs.git = {
    enable = true;
    userName = "Francesco Bozzo";
    userEmail = "francesco.bozzo.99@gmail.com";
    ignores = [ ".DS_Store" ];

    aliases = {
      dag = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)%an <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };

    # improve git diff
    delta.enable = true;
    delta.options = {
      navigate = true; # use n and N to move between diff sections
      side-by-side = false;
      line-numbers = true;
      hyperlinks = true;
      hyperlinks-file-link-format = "vscode://file/{path}:{line}";
    };

    extraConfig = {
      user.signingkey = "~/.ssh/id_ed25519.pub";

      pull.rebase = true;
      merge.conflictStyle = "zdiff3";

      diff.colorMoved = "default";
    };
  };
}
