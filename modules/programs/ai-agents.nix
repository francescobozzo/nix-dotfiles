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
      ollamaModels = lib.filter (m: m.provider == "ollama") self.llms;
      llamaModels = lib.filter (m: m.provider == "llama") self.llms;
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
        settings = {
          theme = "catppuccin-macchiato";
          provider = {
            ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama (local)";
              options.baseURL = "https://llm.fbozzo.dpdns.org/v1";
              # expected structure -> models = { "qwen3.5:9b" = { name = "qwen3.5:9b"; }; };
              models = lib.listToAttrs (
                map (m: {
                  name = m.name;
                  value = {
                    name = m.name;
                  };
                }) ollamaModels
              );
            };
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
          nixos = {
            command = lib.getExe pkgs.mcp-nixos;
          };
        };
      };
    };
}
