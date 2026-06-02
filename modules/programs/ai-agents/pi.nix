{ self, inputs, ... }:
{
  flake.modules.homeManager.ai-agents =
    {
      pkgs,
      lib,
      ...
    }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      llamaModels = lib.filter (m: m.provider == "llama") self.llms;

      piCatppuccin = pkgs.fetchFromGitHub {
        owner = "sherif-fanous";
        repo = "pi-catppuccin";
        rev = "v0.2.0";
        hash = "sha256-HY4EhTpQnSR9CF4y39Eb5bNbvljNkWy5ViAsaUzo+Lk=";
      };
      piCaveman = pkgs.fetchFromGitHub {
        owner = "jonjonrankin";
        repo = "pi-caveman";
        rev = "v1.0.7";
        hash = "sha256-DhawjQ6tZvG5go4ayPdB+Yup77MjsLF2hFmjxgu9yTQ=";
      };
      piExtensions = ./../../../pi/extensions;
    in
    {
      home.packages = [ llm-agents.pi ];

      home.file.".pi/agent/settings.json" = {
        text = builtins.toJSON {
          theme = "catppuccin-macchiato";
          hideThinkingBlock = false;
          enableInstallTelemetry = false;
          defaultProvider = "ollama";
          defaultModel = "qwen3.6:27b-MTP";
          defaultThinkingLevel = "high";
        };
      };

      home.file.".pi/agent/models.json" = {
        text = builtins.toJSON {
          providers = {
            ollama = {
              baseUrl = "https://llama.fbozzo.dpdns.org/v1";
              api = "openai-completions";
              apiKey = "ollama";
              models = map (m: {
                id = m.name;
                contextWindow = m.contextWindow;
              }) llamaModels;
            };
          };
        };
      };

      home.file.".pi/agent/extensions" = {
        source = piExtensions;
        recursive = true;
      };

      home.file.".pi/agent/extensions/caveman.ts" = {
        source = piCaveman + "/extensions/caveman.ts";
      };

      home.file.".pi/agent/themes" = {
        source = piCatppuccin + "/themes";
        recursive = true;
      };
    };
}
