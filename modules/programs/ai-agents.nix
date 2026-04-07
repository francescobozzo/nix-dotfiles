{
  flake.modules.homeManager.ai-agents =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        unstable.gemini-cli
        unstable.antigravity
      ];

      # Use the following command to instantiate claude code with ollama models
      #   claude --model qwen3.5:9b
      programs.claude-code = {
        enable = true;
        package = pkgs.unstable.claude-code;
        # enableMcpIntegration = true; TODO: uncomment when it moves out of unstable
      };

      # https://github.com/sst/opencode/issues/1890
      programs.opencode = {
        enable = true;
        package = pkgs.unstable.opencode;
        enableMcpIntegration = true;
        settings = {
          theme = "catppuccin-macchiato";
          provider = {
            ollama = {
              npm = "@ai-sdk/openai-compatible";
              name = "Ollama (local)";
              options.baseURL = "https://llm.fbozzo.dpdns.org/v1";
              models = {
                "qwen3.5:9b" = {
                  name = "qwen3.5:9b";
                };
                "qwen3.5:27b" = {
                  name = "qwen3.5:27b";
                };
              };
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
