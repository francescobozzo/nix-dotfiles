{ inputs, ... }:
{
  flake.modules.nixos.hermes =
    { config, ... }:
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
            base_url = "https://llama.fbozzo.dpdns.org/v1";
          };
        };
      };
    };
}
