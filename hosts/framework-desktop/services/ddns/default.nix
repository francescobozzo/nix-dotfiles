{ config, ... }:
{
  services.cloudflare-dyndns = {
    enable = true;
    domains = [
      "fbozzo.dpdns.org"
      "whoami.fbozzo.dpdns.org"
      "pihole.fbozzo.dpdns.org"
      "webui.fbozzo.dpdns.org"
      "hass.fbozzo.dpdns.org"
      "llm.fbozzo.dpdns.org"
      "glance.fbozzo.dpdns.org"
      # "prometheus.fbozzo.dpdns.org"
    ];
    proxied = false;
    ipv4 = true;
    ipv6 = true;
    deleteMissing = true;
    apiTokenFile = config.sops.secrets.api-token.path;
  };

  sops.secrets.api-token = {
    format = "yaml";
    mode = "0440";
    restartUnits = [ "cloudflare-dyndns.service" ];
    sopsFile = ./cloudflare-dyndns-secrets.yaml;
  };
}
