{ lib, ... }:
{
  options.flake.llms = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          provider = lib.mkOption {
            type = lib.types.enum [
              "ollama"
              "llama"
            ];
          };
          huggingFace = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              HuggingFace model reference for llama provider.
              Expected format: <repo>/<model>-GGUF:<tag> (e.g., unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL)
            '';
          };
          llamaArgs = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Additional arguments to pass to llama runner.";
          };
          supportImages = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether the model supports image input in zed-editor.";
          };
        };
      }
    );
    default = [ ];
    description = "Available LLM model definitions.";
  };

  config.flake.llms = [
    {
      name = "qwen3.5:0.8b";
      provider = "llama";
      huggingFace = "unsloth/Qwen3.5-0.8B-GGUF:UD-Q4_K_XL";
      llamaArgs = "--temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.00 -ngl 999 --no-mmap -fa 1 --no-webui --kv-unified -c 262144";
      supportImages = true;
    }
    {
      name = "qwen3.6:27b-draft-qwen3.5:0.8b";
      provider = "llama";
      huggingFace = "unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL";
      llamaArgs = "-hfd unsloth/Qwen3.5-0.8B-GGUF:UD-Q4_K_XL --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.00 -ngl 999 --no-mmap -fa 1 --no-webui --kv-unified -c 262144";
      supportImages = true;
    }
    {
      name = "qwen3.6:27b-MTP";
      provider = "llama";
      huggingFace = "unsloth/Qwen3.6-27B-MTP-GGUF:UD-Q4_K_XL";
      llamaArgs = "--spec-type draft-mtp --spec-draft-n-max 3 --spec-draft-p-min 0.75 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --presence-penalty 0.0 --repeat-penalty 1.0 -ngl all --no-mmap -fa 1 --no-webui --kv-unified -c 262144";
      supportImages = true;
    }
    {
      name = "qwen3.6:35b-MTP";
      provider = "llama";
      huggingFace = "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_XL";
      llamaArgs = "--spec-type draft-mtp --spec-draft-n-max 3 --spec-draft-p-min 0.75 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --presence-penalty 0.0 --repeat-penalty 1.0 -ngl all --no-mmap -fa 1 --no-webui --kv-unified -c 262144";
      supportImages = true;
    }
  ];
}
