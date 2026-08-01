{
  flake.modules.nixos.fd = { pkgs, lib, ... }: {
    virtualisation = {
      oci-containers.backend = "docker";
      podman.enable = false;
      docker = {
        enable = true;
        enableOnBoot = true;
        package = pkgs.unstable.docker; # https://github.com/nektos/act/issues/6092
        autoPrune = {
          enable = true;
          flags = [ ];
          dates = "weekly";
        };
      };
    };
  };
}
