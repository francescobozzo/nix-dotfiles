{ inputs, ... }:
{
  flake.modules.nixos.ai =
    { config, ... }:
    let
      llamaService = builtins.head (builtins.filter (s: s.name == "llama") config.fb.services);
    in
    {
      imports = [
        inputs.hermes-agent.nixosModules.default
      ];

      sops = {
        secrets = {
          hermes-env.restartUnits = [ "hermes-agent.service" ];
        };
      };

      services.hermes-agent = {
        enable = true;
        environmentFiles = [ config.sops.secrets."hermes-env".path ];
        addToSystemPackages = true;
        extraDependencyGroups = [ "messaging" ];
        settings = {
          model = {
            default = "qwen3.6:35b-MTP";
            provider = "custom";
            base_url = "https://${llamaService.subdomain}.fbozzo.dpdns.org/v1";
          };
        };
      };
    };
}
