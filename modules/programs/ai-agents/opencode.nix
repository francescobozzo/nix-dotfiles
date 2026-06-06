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
      # TODO: remove override when https://github.com/NixOS/nixpkgs/pull/527159 lands
      mcp-nixos = if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.mcp-nixos.overrideAttrs (old: {
          disabledTests = (old.disabledTests or []) ++ [ "test_read_text_file" ];
        })
      else pkgs.mcp-nixos;
    in
    {
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
          nixos = {
            command = lib.getExe mcp-nixos;
          };
        };
      };
    };
}
