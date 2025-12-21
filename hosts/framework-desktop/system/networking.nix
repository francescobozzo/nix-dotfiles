{ hostname, ... }:
{
  networking = {
    hostName = hostname;
    useDHCP = false;
    defaultGateway = "192.168.1.254";
    nameservers = [ "192.168.1.89" ];

    interfaces.wlp192s0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.89";
          prefixLength = 24;
        }
      ];
    };

    networkmanager = {
      enable = true;
      wifi.powersave = true;
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
