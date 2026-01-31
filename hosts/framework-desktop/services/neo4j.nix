{ ... }:
{
  networking.firewall.allowedTCPPorts = [
    7474
    7687
  ];

  services.neo4j = {
    enable = true;
    bolt = {
      enable = true;
      tlsLevel = "DISABLED";
      listenAddress = ":7687";
    };
    http = {
      enable = true;
      listenAddress = ":7474";
    };
    https.enable = false;
    defaultListenAddress = "0.0.0.0";
  };
}
