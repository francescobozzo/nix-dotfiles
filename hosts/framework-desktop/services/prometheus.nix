{ config, hostname, ... }:
{
  services.prometheus = {
    enable = true;
    retentionTime = "30d";
    alertmanagers = [ ];
    exporters = {
      systemd.enable = true;
      node.enable = true;
    };
    scrapeConfigs = [
      {
        job_name = "systemd";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.systemd.port}" ];
          }
        ];
      }
      {
        job_name = "${hostname}";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "traefik";
        static_configs = [
          {
            targets = [
              "127.0.0.1${config.services.traefik.staticConfigOptions.entryPoints.metrics.address}"
            ];
          }
        ];
      }
    ];
    stateDir = "prometheus2"; # default
    webExternalUrl = "prometheus.fbozzo.dpdns.org";
  };
}
