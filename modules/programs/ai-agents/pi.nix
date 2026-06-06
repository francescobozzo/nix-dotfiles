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
          packages = [
            "npm:pi-mcp-adapter"
            "npm:pi-direnv"
            "git:github.com/jonjonrankin/pi-caveman"
            "git:github.com/otahontas/pi-coding-agent-catppuccin"
          ];
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
    };
}
