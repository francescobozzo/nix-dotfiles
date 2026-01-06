{ config, ... }:
{
  # TODO: compress logs
  # Example: https://github.com/khaneliman/khanelinix/blob/9a9a3318d552e6f89c56f8f7ed8113ae01028681/modules/nixos/services/logrotate/default.nix#L22
  services.logrotate = {
    enable = true;
    settings = {
      header = {
        dateext = true;
        dateformat = "-%Y-%m-%d";
        missingok = true;
      };
      "${config.services.traefik.staticConfigOptions.accessLog.filePath}" = {
        frequency = "daily";
        rotate = 7;
        notifempty = true;
        postrotate = ''
          systemctl kill --signal=USR1 traefik
        '';
      };
    };
  };
}
