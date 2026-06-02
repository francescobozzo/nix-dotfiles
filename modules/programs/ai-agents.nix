{ self, inputs, ... }:
{
  flake.modules.homeManager.ai-agents =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      llamaModels = lib.filter (m: m.provider == "llama") self.llms;

      # Pi sources (fetched from GitHub, pinned to tags)
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
      piExtensions = ./../../pi/extensions;
    in
    {
      home.packages =
        (with pkgs; [
          unstable.antigravity
        ])
        ++ (with llm-agents; [
          codex
          gemini-cli
          pi
        ]);

      # Use the following command to instantiate claude code with ollama models
      #   claude --model qwen3.5:9b
      programs.claude-code = {
        enable = true;
        package = llm-agents.claude-code;
        # enableMcpIntegration = true; TODO: uncomment when it moves out of unstable
      };

      programs.zsh.sessionVariables = {
        "ANTHROPIC_AUTH_TOKEN" = "ollama";
        "ANTHROPIC_API_KEY" = "";
        "ANTHROPIC_BASE_URL" = "https://llm.fbozzo.dpdns.org";
      };

      # https://github.com/sst/opencode/issues/1890
      programs.opencode = {
        enable = true;
        package = llm-agents.opencode;
        enableMcpIntegration = true;
        tui = {
          theme = "catppuccin-macchiato";
        };
        settings = {
          provider = {
            llama = {
              npm = "@ai-sdk/openai-compatible";
              name = "llama (local)";
              options.baseURL = "https://llama.fbozzo.dpdns.org/v1";
              # expected structure -> models = { "qwen3.5:9b" = { name = "qwen3.5:9b"; }; };
              models = lib.listToAttrs (
                map (m: {
                  name = m.name;
                  value = {
                    name = m.name;
                  };
                }) llamaModels
              );
            };
          };
        };
      };

      programs.mcp = {
        enable = true;
        servers = {
          # nixos = {
          #   command = lib.getExe pkgs.mcp-nixos;
          # };
        };
      };

      # Pi configuration
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

      # Pi extensions (local hello-world + remote caveman)
      home.file.".pi/agent/extensions" = {
        source = piExtensions;
        recursive = true;
      };

      home.file.".pi/agent/extensions/caveman.ts" = {
        source = piCaveman + "/extensions/caveman.ts";
      };

      # Pi themes - catppuccin (recursive copy)
      home.file.".pi/agent/themes" = {
        source = piCatppuccin + "/themes";
        recursive = true;
      };
    };
}
