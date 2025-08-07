_:

{
  programs.git = {
    enable = true;
    userName = "Francesco Bozzo";
    userEmail = "francesco.bozzo.99@gmail.com";
    ignores = [ ".DS_Store" ];

    extraConfig = {
      user.signingkey = "~/.ssh/id_ed25519.pub";

      pull.rebase = true;
    };
  };
}
