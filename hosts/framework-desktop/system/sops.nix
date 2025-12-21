{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sops
    age
  ];
  sops = {
    defaultSopsFile = ./neos-secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  sops.secrets.wifi = {
    format = "dotenv";
    restartUnits = [ "NetworkManager.service" ];
    sopsFile = ./neos-secrets.env;
    key = ""; # to map the whole file as a secret
  };
}
