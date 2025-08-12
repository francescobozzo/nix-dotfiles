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

    extraConfig = {
      user.signingkey = "~/.ssh/id_ed25519.pub";

      pull.rebase = true;
    };
  };
}
