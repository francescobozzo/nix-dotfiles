{
  flake.modules.nixos.trilium =
    { config, pkgs, ... }:
    {
      services.trilium-server = {
        enable = true;
        port = 12783;
        package = pkgs.unstable.trilium-server;
        noAuthentication = true;
      };

      fb.services = [
        {
          name = "trilium";
          subdomain = "notes";
          port = config.services.trilium-server.port;
          category = "misc";
          icon = "di:trilium";
          toBackup = [
            config.services.trilium-server.dataDir
          ];
          gatusHealthcheckEndpoint = "/api/health-check";
          extraGatusConditions = [
            "[BODY].status == ok"
          ];
        }
      ];
    };
}
