{
  nix = {
    enable = true;
    settings.experimental-features = "nix-command flakes";
    optimise.automatic = true;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.hostPlatform = "x86_64-linux";
  nixpkgs.config.rocmSupport = true;

  system.stateVersion = "25.05";
}
