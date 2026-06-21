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
      llamaModels = self.llms;
    in
    {
      home.packages = [ llm-agents.pi ];

      home.file.".pi/agent/settings.json" = {
        text = builtins.toJSON {
          theme = "catppuccin-macchiato";
          hideThinkingBlock = false;
          enableInstallTelemetry = false;
          defaultProvider = "llama";
          defaultModel = "qwen3.6:27b-MTP";
          defaultThinkingLevel = "high";
          packages = [
            "npm:pi-mcp-adapter"
            "npm:pi-direnv"
            "git:github.com/jonjonrankin/pi-caveman"
            "git:github.com/otahontas/pi-coding-agent-catppuccin"
            "npm:@juicesharp/rpiv-web-tools"
          ];
        };
      };

      home.file.".pi/agent/models.json" = {
        text = builtins.toJSON {
          providers = {
            llama = {
              baseUrl = "https://llama.fbozzo.dpdns.org/v1";
              api = "openai-completions";
              apiKey = "placeholder";
              models = map (m: {
                id = m.name;
                contextWindow = m.contextWindow;
                input = [ "text" ] ++ (if m.supportImages then [ "image" ] else [ ]);
              }) llamaModels;
            };
          };
        };
      };

      home.file.".config/rpiv-web-tools/config.json" = {
        text = builtins.toJSON {
          provider = "searxng";
          baseUrls.searxng = "https://search.fbozzo.dpdns.org";
          # TODO: install gh cli for better support
          interceptors.github = {
            maxRepoSizeMB = 1000;
            cloneTimeoutSeconds = 90;
            clonePath = "/tmp";
          };
        };
      };
    };
}
