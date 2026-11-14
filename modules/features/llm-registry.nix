{ config, lib, ... }:
{
  options.flake.llms = lib.mkOption {
    type = lib.types.listOf (
      lib.types.addCheck
        (lib.types.submodule {
          options = {
            name = lib.mkOption { type = lib.types.str; };
            provider = lib.mkOption {
              type = lib.types.enum [
                "llama-server"

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
              type = lib.types.nullOr lib.types.ints.positive;
              default = null;
              description = "Context window size; required except for gufo image, video, and embedding models.";
            };
            reasoningEffort = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
              default = null;
              description = "Available reasoning effort levels for the model (e.g., low, medium, xhigh).";
            };
            extraArgs = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Additional arguments passed to the provider command.";
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
                  "embedding"
                  "tts"
                  "asr"
                ]
              );
              default = null;
              description = ''
                Model modality; null defaults to llm. Non-llm modalities are excluded
                from chat clients. For gufo, this also selects the serve subcommand.
              '';
            };
            supportImages = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the model supports image input in zed-editor.";
            };
          };
        })
        (
          m:
          if
            m.provider == "gufo"
            && lib.elem m.modality [
              "image"
              "video"
              "embedding"
            ]
          then
            m.contextWindow == null
          else
            m.contextWindow != null
        )
    );
    default = [ ];
    description = "Available LLM model definitions.";
  };

  options.flake.chatLlms = lib.mkOption {
    type = lib.types.listOf lib.types.raw;
    readOnly = true;
    description = "Models exposed through the chat-completions API.";
  };

  config.flake = {
    chatLlms = lib.filter (m: m.modality == null || m.modality == "llm") config.flake.llms;
  };
}
