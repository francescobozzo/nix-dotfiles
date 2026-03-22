{ pkgs-unstable, ... }:
{
  # https://github.com/sst/opencode/issues/1890
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;
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
          };
        };
      };
    };
  };
}
