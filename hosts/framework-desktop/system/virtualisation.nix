{
  virtualisation = {
    oci-containers.backend = "docker";
    podman.enable = false;
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        flags = [ ];
        dates = "weekly";
      };
    };
  };
}
