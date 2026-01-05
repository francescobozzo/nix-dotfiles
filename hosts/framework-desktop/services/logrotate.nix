{ config, ... }:
{
  services.logrotate = {
    enable = true;
    settings = {
      "${config.services.traefik.staticConfigOptions.accessLog.filePath}" = {
        frequency = "daily";
        rotate = 7;
        missingok = true;
        notifempty = true;
        postrotate = ''
          systemctl kill --signal=USR1 traefik
        '';
      };
    };
  };
}
