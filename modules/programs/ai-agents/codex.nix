{ inputs, ... }:
{
  flake.modules.homeManager.ai-agents =
    { pkgs, ... }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs.codex = {
        enable = true;
        package = llm-agents.codex;
      };
    };
}
