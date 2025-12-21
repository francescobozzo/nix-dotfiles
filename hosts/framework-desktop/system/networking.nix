{ config, hostname, ... }:

let
  localIp = "192.168.1.89";
  modelIp = "192.168.1.254";
in
{
  networking = {
    hostName = hostname;
    useDHCP = false;
    defaultGateway = modelIp;
    nameservers = [ localIp ];

    interfaces.wlp192s0 = {
      ipv4.addresses = [
        {
          address = localIp;
          prefixLength = 24;
        }
      ];
    };

    networkmanager = {
      enable = true;
      wifi.powersave = true;
      ensureProfiles = {
        environmentFiles = [
          config.sops.secrets.wifi.path
        ];
        profiles."HomeNetwork" = {
          connection = {
            id = "HomeNetwork";
            type = "wifi";
            autoconnect = true;
          };

          wifi = {
            mode = "infrastructure";
            ssid = "$WIFI_SSID";
          };

          ipv4 = {
            address1 = "${localIp}/24";
            dns = localIp;
            gateway = modelIp;
            method = "manual";
          };

          wifi-security = {
            key-mgmt = "wpa-psk"; # WPA2
            psk = "$WIFI_PSW";
          };
        };
      };
    };
  };

  services.tailscale.enable = true;

  services.openssh.enable = true;

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "100.64.0.0/10" # https://tailscale.com/kb/1304/ip-pool
    ];
    bantime = "24h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
    jails = { }; # TODO: add reverse proxy
  };
}
