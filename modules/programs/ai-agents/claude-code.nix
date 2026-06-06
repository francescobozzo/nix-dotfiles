{ inputs, ... }:
{
  flake.modules.homeManager.ai-agents =
    { pkgs, ... }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      # Use the following command to instantiate claude code with local models
      #   claude --model qwen3.5:9b
      programs.claude-code = {
        enable = true;
        package = llm-agents.claude-code;
        enableMcpIntegration = true;
      };

      programs.zsh.sessionVariables = {
        "ANTHROPIC_AUTH_TOKEN" = "";
        "ANTHROPIC_API_KEY" = "";
        "ANTHROPIC_BASE_URL" = "https://llama.fbozzo.dpdns.org";
      };
    };
}
