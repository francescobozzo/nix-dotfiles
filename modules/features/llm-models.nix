{
  flake.modules.homeManager.llm-models =
    { lib, ... }:
    {
      options.llms = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption { type = lib.types.str; };
              provider = lib.mkOption { type = lib.types.enum [ "ollama" ]; };
            };
          }
        );
        default = [ ];
        description = "Available LLM model definitions.";
      };

      config.llms = [
        {
          name = "qwen3.5:9b";
          provider = "ollama";
        }
        {
          name = "qwen3.6:27b";
          provider = "ollama";
        }
        {
          name = "qwen3.6:35b";
          provider = "ollama";
        }
      ];
    };
}
