{ lib, ... }:
{
  options.flake.llms = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          provider = lib.mkOption {
            type = lib.types.enum [
              "llama-server"
              "ds4-server"
              "flm"
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
          contextWindow = lib.mkOption {
            type = lib.types.int;
            description = "Context window size for the model.";
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
      provider = "llama-server";
      contextWindow = 262144;
      huggingFace = "unsloth/Qwen3.5-0.8B-GGUF:UD-Q4_K_XL";
      llamaArgs = "--temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.00 -ngl 999 --no-mmap -fa 1 --no-ui --kv-unified";
      supportImages = true;
    }
    {
      name = "qwen3.6:27b-MTP";
      provider = "llama-server";
      contextWindow = 262144;
      huggingFace = "unsloth/Qwen3.6-27B-MTP-GGUF:UD-Q4_K_XL";
      llamaArgs = "--spec-type draft-mtp --spec-draft-n-max 3 --spec-draft-p-min 0.75 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --presence-penalty 0.0 --repeat-penalty 1.0 -ngl all --no-mmap -fa 1 --no-ui --kv-unified --ubatch-size 2048 --batch-size 4096 --chat-template-kwargs '{\"preserve_thinking\": true}'";
      supportImages = true;
    }
    {
      name = "qwen3.6:35b-MTP";
      provider = "llama-server";
      contextWindow = 262144;
      huggingFace = "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_XL";
      llamaArgs = "--spec-type draft-mtp --spec-draft-n-max 3 --spec-draft-p-min 0.75 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --presence-penalty 0.0 --repeat-penalty 1.0 -ngl all --no-mmap -fa 1 --no-ui --kv-unified --ubatch-size 2048 --batch-size 4096 --chat-template-kwargs '{\"preserve_thinking\": true}'";
      supportImages = true;
    }
    {
      name = "laguna-S-2.1";
      provider = "llama-server";
      contextWindow = 262144;
      huggingFace = "poolside/Laguna-S-2.1-GGUF:Q4_K_M";
      # -hfd poolside/Laguna-S-2.1-GGUF:DFlash-BF16 --spec-type draft-dflash --spec-draft-n-max 15
      llamaArgs = "-ngl all --no-mmap -fa 1 --no-ui --kv-unified --jinja --ubatch-size 4096 --batch-size 4096";
      supportImages = true;
    }
    {
      name = "ds4";
      provider = "ds4-server";
      contextWindow = 262144;
      llamaArgs = "--kv-disk-dir /tmp/ds4-kv --kv-disk-space-mb 8192 -m /var/llms/huggingface/hub/models--antirez--deepseek-v4-gguf/snapshots/9170bf42beb77f38006e016503ecace31f2bd9a0/DeepSeek-V4-Flash-IQ2XXS-w2Q2K-AProjQ8-SExpQ8-OutQ8-chat-v2-imatrix.gguf";
      supportImages = false;
    }
    {
      name = "qwen3.5:2b";
      provider = "flm";
      contextWindow = 262144;
      llamaArgs = "--pmode turbo";
      supportImages = true;
    }
  ];
}
