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
              "gufo"
              "openrouter"
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
          reasoningEffort = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            description = "Available reasoning effort levels for the model (e.g., low, medium, xhigh).";
          };
          llamaArgs = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Additional arguments to pass to llama runner.";
          };
          modelPath = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Local path to model weights for the gufo provider
              (e.g., /var/llms/huggingface/hub/models--Qwen--Qwen3-ASR-1.7B/snapshots/<revision>).
            '';
          };
          modality = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.enum [
                "llm"
                "video"
                "image"
                "tts"
                "asr"
              ]
            );
            default = null;
            description = ''
              gufo modality served by gufo-server (null defaults to llm).
              "tts"/"asr" are standalone speech subcommands; "image" serves
              Qwen-Image-2.1, "video" serves MiniMax H3 text-to-video.
            '';
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
      name = "qwen3.8:27b-MTP";
      provider = "llama-server";
      contextWindow = 262144;
      reasoningEffort = [
        "xhigh"
        "medium"
        "low"
      ];
      huggingFace = "unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_XL";
      llamaArgs = "--spec-type draft-mtp --spec-draft-n-max 4 --spec-draft-p-min 0.75 --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.00 --presence-penalty 0.0 --repeat-penalty 1.0 -ngl all --no-mmap -fa 1 --no-ui --kv-unified --ubatch-size 2048 --batch-size 4096 --chat-template-kwargs '{\"preserve_thinking\": true}'";
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
      name = "ds4-0731";
      provider = "ds4-server";
      contextWindow = 262144;
      reasoningEffort = [
        "high"
        "max"
      ];
      llamaArgs = "--kv-disk-dir /tmp/ds4-kv --kv-disk-space-mb 8192 -m /var/llms/huggingface/hub/models--antirez--deepseek-v4-gguf/snapshots/1cd7b564460821938add0475a60b942c409295e0/DeepSeek-V4-Flash-IQ2XXS-w2Q2K-AProjQ8-SExpQ8-OutQ8-chat-v2-imatrix-0731.gguf";
      supportImages = false;
    }
    {
      name = "qwen3.5:2b";
      provider = "flm";
      contextWindow = 262144;
      llamaArgs = "--pmode turbo";
      supportImages = true;
    }
    {
      name = "deepseek/deepseek-v4-flash-vision-exp";
      provider = "openrouter";
      contextWindow = 1048576;
      supportImages = true;
    }
    {
      name = "z-ai/glm-5.3-flash";
      provider = "openrouter";
      contextWindow = 1310720;
      supportImages = true;
    }

    {
      name = "gufo-ds4-0731";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "high"
        "max"
      ];
      modelPath = "/var/llms/huggingface/hub/models--antirez--deepseek-v4-gguf/snapshots/1cd7b564460821938add0475a60b942c409295e0/DeepSeek-V4-Flash-IQ2XXS-w2Q2K-AProjQ8-SExpQ8-OutQ8-chat-v2-imatrix-0731.gguf";
      llamaArgs =
        "--temperature 1 --top-p 0.95 --speculative dspark"
        + " --dspark-model /var/llms/huggingface/hub/models--antirez--deepseek-v4-gguf/snapshots/e7f04037032990db0346398d249baf9fb9df1ccc/DeepSeek-V4-Flash-DSpark-support-0731.gguf";
      supportImages = false;
    }

    # MiniMax H3 text-to-video (gufo serve video). contextWindow is unused by
    # the video modality; jobs persist under --root with --ttl retention.
    # POST /v1/videos with model "minimax-h3" (exact preset; also accepts
    # minimax-h3-fast/aggressive/dev/fullres).
    {
      name = "minimax-h3";
      provider = "gufo";
      modality = "video";
      contextWindow = 8192; # unused: video modality has no context budget
      modelPath = "/var/llms/huggingface/hub/models--MiniMaxAI--MiniMax-H3/snapshots/42ed227ee7df40d41602854ae760620d6eb651fe";
      llamaArgs = "--root /var/llms/huggingface/gufo-h3-jobs --ttl 3600";
      supportImages = false;
    }

    # Qwen3 audio services (gufo serve tts / serve asr, separate processes).
    # --served-model-name now applies to speech too: each server's model_id
    # equals its llama-swap name, so client requests pass validation.
    {
      name = "qwen3-asr";
      provider = "gufo";
      modality = "asr";
      contextWindow = 1024; # --context
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen3-ASR-1.7B/snapshots/7278e1e70fe206f11671096ffdd38061171dd6e5";
      supportImages = false;
    }
    {
      name = "qwen3-tts";
      provider = "gufo";
      modality = "tts";
      contextWindow = 4096; # --context
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen3-TTS-12Hz-1.7B-CustomVoice/snapshots/0c0e3051f131929182e2c023b9537f8b1c68adfe";
      supportImages = false;
    }

    # Qwen3.8 Flash-Next with native MTP (shared-Q8 predictor). Four-shard
    # target: pass the first shard, the loader discovers the rest. mmproj is
    # two levels up from the target shard (gufo walks two levels for the
    # projector).
    {
      name = "gufo-qwen3.8-flash-next";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "xhigh"
        "medium"
        "low"
      ];
      modelPath = "/var/llms/huggingface/hub/models--unsloth--Qwen3.8-Flash-Next-GGUF/snapshots/38bb39ee97821de2c9009abb7e93950eec396e66/UD-Q4_K_XL/Qwen3.8-Flash-Next-UD-Q4_K_XL-00001-of-00004.gguf";
      llamaArgs =
        "--speculative mtp --mtp-model /var/llms/huggingface/hub/models--unsloth--Qwen3.8-Flash-Next-GGUF/snapshots/38bb39ee97821de2c9009abb7e93950eec396e66/MTP/mtp-Qwen3.8-Flash-Next-shared-Q8_0.gguf"
        + " --sessions 2 --temperature 1.0 --top-p 0.95 --top-k 20 --min-p 0.0";
      supportImages = true;
    }

    # Qwen3.8 27B with DFlash2 (Q4_K_M draft). Targets and drafts need not
    # match precision; mmproj sits beside each target for image input.
    {
      name = "gufo-qwen3.8:27b-Q8-dflash2";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "xhigh"
        "medium"
        "low"
      ];
      modelPath = "/var/llms/huggingface/hub/models--unsloth--Qwen3.8-27B-GGUF/snapshots/4ca720788d1e01f1bff70c033e0d0028fd02e502/Qwen3.8-27B-UD-Q8_K_XL.gguf";
      llamaArgs =
        "--speculative dflash2 --dflash-model /var/llms/huggingface/hub/models--z-lab--Qwen3.8-27B-DFlash2-GGUF/snapshots/2d9571f8ce46e151f61c6499c99dee6079e1d610/Qwen3.8-27B-DFlash2-Q4_K_M.gguf"
        + " --sessions 2 --temperature 1.0 --top-p 0.95 --top-k 20 --min-p 0.0";
      supportImages = true;
    }
    {
      name = "gufo-qwen3.8:27b-Q4-dflash2";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "xhigh"
        "medium"
        "low"
      ];
      modelPath = "/var/llms/huggingface/hub/models--unsloth--Qwen3.8-27B-GGUF/snapshots/4ca720788d1e01f1bff70c033e0d0028fd02e502/Qwen3.8-27B-UD-Q4_K_XL.gguf";
      llamaArgs =
        "--speculative dflash2 --dflash-model /var/llms/huggingface/hub/models--z-lab--Qwen3.8-27B-DFlash2-GGUF/snapshots/2d9571f8ce46e151f61c6499c99dee6079e1d610/Qwen3.8-27B-DFlash2-Q4_K_M.gguf"
        + " --sessions 2 --temperature 1.0 --top-p 0.95 --top-k 20 --min-p 0.0";
      supportImages = true;
    }

    # Qwen-Image-2.1 generation/editing (gufo serve image). The served model
    # ID must equal the llama-swap name: image requests are validated against
    # --served-model-name. Larger uploads need --max-request-bytes.
    {
      name = "Qwen-Image-2.1";
      provider = "gufo";
      modality = "image";
      contextWindow = 8192; # unused: image modality has no context budget
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen-Image-2.1/snapshots/b3179ad355be050328e483a9dfdd9e60cd62adfa";
      llamaArgs = "--max-request-bytes 33554432";
      supportImages = false;
    }
  ];
}
