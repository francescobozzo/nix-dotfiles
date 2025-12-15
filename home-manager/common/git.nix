{
  programs.git = {
    enable = true;

    settings = {
      user.email = "francesco.bozzo.99@gmail.com";
      user.name = "Francesco Bozzo";

      pull.rebase = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      diff.colorMoved = "default";

      alias = {
        dag = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)%an <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
    ignores = [ ".DS_Store" ];

    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
  };

  # improve git diff
  programs.delta = {
    enable = true;
    options = {
      navigate = true; # use n and N to move between diff sections
      side-by-side = false;
      line-numbers = true;
      hyperlinks = true;
      hyperlinks-file-link-format = "vscode://file/{path}:{line}";
    };
  };
}
