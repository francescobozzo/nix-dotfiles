{
  flake.modules.nixos.ddns =
    { config, ... }:
    {
      services.cloudflare-dyndns = {
        enable = true;
        domains = [
          "fbozzo.dpdns.org"
        ]
        ++ (builtins.map (service: "${service.subdomain}.fbozzo.dpdns.org") config.fb.services);
        proxied = false;
        ipv4 = true;
        ipv6 = true;
        deleteMissing = true;
        apiTokenFile = config.sops.secrets.cloudflare-dyndns-api-token.path;
      };
    };
}
