{ inputs, ... }:
{
  flake.modules.nixos.fd =
    { pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = with pkgs; [
        sops
        age
      ];

      sops = {
        defaultSopsFile = ../../../secrets/neos-secrets.yaml;
        defaultSopsFormat = "yaml";
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

        secrets = {
          wifi.restartUnits = [ "NetworkManager.service" ];
          traefik.restartUnits = [ "traefik.service" ];
          cloudflare-dyndns-api-token.restartUnits = [ "cloudflare-dyndns.service" ];

          "backblaze/environment" = { };
          "backblaze/repository" = { };
          "backblaze/password" = { };
        };
      };
    };
}
