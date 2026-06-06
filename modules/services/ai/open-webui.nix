{ ... }:
{
  flake.modules.nixos.ai =
    { config, pkgs, ... }:
    {
      services.open-webui = {
        enable = true;
        port = 9292;
        environment = {
          OPENAI_API_BASE_URL = "http://localhost:${toString config.services.llama-swap.port}";
        };
        package = pkgs.unstable.open-webui;
      };
    };
}
