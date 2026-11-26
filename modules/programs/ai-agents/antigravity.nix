{ inputs, ... }:
{
  flake.modules.homeManager.ai-agents =
    { pkgs, ... }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      home.packages = [
        llm-agents.antigravity-cli
      ];
      fb.herdr.integrations = [ "antigravity-cli" ];
    };
}
