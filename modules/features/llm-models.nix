# Models exposed by llama-swap and its clients.
{
  flake.llms = [
    {
      name = "deepseek/deepseek-v4.1-flash-1017";
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
      extraArgs =
        "--speculative dspark --dspark-model /var/llms/huggingface/hub/models--antirez--deepseek-v4-gguf/snapshots/e7f04037032990db0346398d249baf9fb9df1ccc/DeepSeek-V4-Flash-DSpark-support-0731.gguf"
        + " --sessions 2 -v";
      supportImages = false;
    }
    {
      name = "gufo-ds4.1-flash";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "low"
        "high"
        "max"
      ];
      modelPath = "/var/llms/huggingface/hub/models--unsloth--DeepSeek-V4.1-Flash-1017-GGUF/snapshots/2688c0c3c2c3b052ec4f6d10a8417b0ef7ee4eba/UD-IQ2_XXS/DeepSeek-V4.1-Flash-1017-UD-IQ2_XXS-00001-of-00006.gguf";
      extraArgs =
        "--stream-experts --sessions 1 --expert-cache-bytes 98784247808 --speculative dspark"
        + " --dspark-model /var/llms/huggingface/hub/models--Lucebox--DeepSeek-V4.1-Flash-1017-ROCMFP-GGUF/snapshots/ba58445f0818edfc69e680390bc9b4873af8a621/DeepSeek-V4.1-Flash-1017-DSpark-draft-Q2K-Q4K.gguf"
        + " --mmproj /var/llms/huggingface/hub/models--unsloth--DeepSeek-V4.1-Flash-1017-GGUF/snapshots/2688c0c3c2c3b052ec4f6d10a8417b0ef7ee4eba/mmproj-BF16.gguf";
      supportImages = true;
    }
    {
      name = "gufo-lfm3-1.7b";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "high"
      ];
      modelPath = "/var/llms/huggingface/hub/models--LiquidAI--LFM3-1.7B-GGUF/snapshots/b3f2ae5d73cd3c91bf40e8ba752c648aa05dffdf/LFM3-1.7B-Q8_0.gguf";
    }
    {
      name = "gufo-lfm3-vl-2b";
      provider = "gufo";
      contextWindow = 128000;
      reasoningEffort = [
        "high"
      ];
      modelPath = "/var/llms/huggingface/hub/models--LiquidAI--LFM3-VL-2B-GGUF/snapshots/b36554cfd35854b06429900131730cd80f092cdb/LFM3-VL-2B-Q8_0.gguf";
      extraArgs = "--mmproj /var/llms/huggingface/hub/models--LiquidAI--LFM3-VL-2B-GGUF/snapshots/b36554cfd35854b06429900131730cd80f092cdb/mmproj-LFM3-VL-2B-BF16.gguf";
      supportImages = true;
    }
    {
      name = "gufo-lfm3-audio-2b-asr";
      provider = "gufo";
      modality = "asr";
      contextWindow = 8192;
      modelPath = "/var/llms/huggingface/hub/models--LiquidAI--LFM3-Audio-2B-GGUF/snapshots/02355c1a141e464a064f2ab2c276638dbcb7f38a/LFM3-Audio-2B-Q8_0.gguf";
      extraArgs = "--mmproj /var/llms/huggingface/hub/models--LiquidAI--LFM3-Audio-2B-GGUF/snapshots/02355c1a141e464a064f2ab2c276638dbcb7f38a/mmproj-LFM3-Audio-2B-BF16.gguf";
    }
    {
      name = "gufo-lfm3-audio-2b-tts";
      provider = "gufo";
      modality = "tts";
      contextWindow = 8192;
      modelPath = "/var/llms/huggingface/hub/models--LiquidAI--LFM3-Audio-2B-GGUF/snapshots/02355c1a141e464a064f2ab2c276638dbcb7f38a/LFM3-Audio-2B-Q8_0.gguf";
      extraArgs = "--mmproj /var/llms/huggingface/hub/models--LiquidAI--LFM3-Audio-2B-GGUF/snapshots/02355c1a141e464a064f2ab2c276638dbcb7f38a/mmproj-LFM3-Audio-2B-BF16.gguf";
    }
    {
      name = "gufo-d1-omni-2b";
      provider = "gufo";
      modality = "decision";
      contextWindow = 16384;
      modelPath = "/var/llms/huggingface/hub/models--LiquidAI--d1-Omni-2B-GGUF/snapshots/c53ae0b1f92b17065e9158d34019c9ca1ea5bcf8/d1-Omni-2B-Q8_0.gguf";
      extraArgs = "--mmproj /var/llms/huggingface/hub/models--LiquidAI--d1-Omni-2B-GGUF/snapshots/c53ae0b1f92b17065e9158d34019c9ca1ea5bcf8/mmproj-d1-Omni-2B-BF16.gguf";
    }
    {
      name = "gufo-qwen3.8-flash-next";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "xhigh"
        "medium"
        "low"
      ];
      modelPath = "/var/llms/huggingface/hub/models--unsloth--Qwen3.8-Flash-Next-GGUF/snapshots/d96201194f103c906994f283f504209dc8d2a10c/UD-Q4_K_XL/Qwen3.8-Flash-Next-UD-Q4_K_XL-00001-of-00004.gguf";
      extraArgs =
        "--speculative mtp --mtp-model /var/llms/huggingface/hub/models--unsloth--Qwen3.8-Flash-Next-GGUF/snapshots//d96201194f103c906994f283f504209dc8d2a10c/MTP/mtp-Qwen3.8-Flash-Next-shared-Q8_0.gguf"
        + " --sessions 2 -v";
      supportImages = true;
    }
    {
      name = "gufo-inkling-2-mini";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "high"
        "xhigh"
        "medium"
        "low"
      ];
      modelPath = "/var/llms/huggingface/hub/models--unsloth--Inkling-2-Mini-GGUF/snapshots/8078d149286eec7193795413b9e0643da6d11fa1/Inkling-2-Mini-UD-Q4_K_XL.gguf";
      extraArgs =
        "--speculative dspark --dspark-model /var/llms/huggingface/hub/models--unsloth--Inkling-2-Mini-GGUF/snapshots/8078d149286eec7193795413b9e0643da6d11fa1/dspark-Inkling-2-Mini-Q8_0.gguf"
        + " --mmproj /var/llms/huggingface/hub/models--unsloth--Inkling-2-Mini-GGUF/snapshots/8078d149286eec7193795413b9e0643da6d11fa1/mmproj-BF16.gguf"
        + " --sessions 2 -v";
      supportImages = true;
    }
    # {
    #   name = "gufo-qwen3.8:27b-Q8-dflash2";
    #   provider = "gufo";
    #   contextWindow = 262144;
    #   reasoningEffort = [
    #     "xhigh"
    #     "medium"
    #     "low"
    #   ];
    #   modelPath = "/var/llms/huggingface/hub/models--unsloth--Qwen3.8-27B-GGUF/snapshots/4ca720788d1e01f1bff70c033e0d0028fd02e502/Qwen3.8-27B-UD-Q8_K_XL.gguf";
    #   extraArgs =
    #     "--speculative dflash2 --dflash-model /var/llms/huggingface/hub/models--z-lab--Qwen3.8-27B-DFlash2-GGUF/snapshots/2d9571f8ce46e151f61c6499c99dee6079e1d610/Qwen3.8-27B-DFlash2-Q4_K_M.gguf"
    #     + " --sessions 2 -v";
    #   supportImages = true;
    # }
    {
      name = "gufo-qwen3.8:27b-Q4-dflash2";
      provider = "gufo";
      contextWindow = 262144;
      reasoningEffort = [
        "xhigh"
        "medium"
        "low"
      ];
      modelPath = "/var/llms/huggingface/hub/models--unsloth--Qwen3.8-27B-GGUF/snapshots/4af51b3542f775b0a8e4b310bfb3f17e01c306c9/Qwen3.8-27B-UD-Q4_K_XL.gguf";
      extraArgs =
        "--speculative dflash2 --dflash-model /var/llms/huggingface/hub/models--z-lab--Qwen3.8-27B-DFlash2-GGUF/snapshots/2d9571f8ce46e151f61c6499c99dee6079e1d610/Qwen3.8-27B-DFlash2-Q4_K_M.gguf"
        + " --sessions 2 -v";
      supportImages = true;
    }
    {
      name = "gufo-Qwen-Image-2.1";
      provider = "gufo";
      modality = "image";
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen-Image-2.1/snapshots/b3179ad355be050328e483a9dfdd9e60cd62adfa";
      extraArgs = "--max-request-bytes 33554432";
      supportImages = false;
    }
    {
      name = "gufo-Qwen-Image-2.1-Turbo";
      provider = "gufo";
      modality = "image";
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen-Image-2.1-Turbo/snapshots/fc13ba1986fcb905854dc8de2f52eee395f49b5b";
      extraArgs = "--max-request-bytes 33554432";
    }
    {
      name = "gufo-embeddinggemma-2";
      provider = "gufo";
      modality = "embedding";
      modelPath = "/var/llms/huggingface/hub/models--google--embeddinggemma-2/snapshots/914f7f89142e33e77833254d9c9b90c3cef7303b";
    }
    {
      name = "gufo-embeddinggemma-2-npu";
      provider = "gufo";
      modality = "embedding";
      modelPath = "/var/llms/huggingface/hub/models--google--embeddinggemma-2/snapshots/914f7f89142e33e77833254d9c9b90c3cef7303b";
      extraArgs = "--npu";
    }
    {
      name = "gufo-minimax-h3";
      provider = "gufo";
      modality = "video";
      modelPath = "/var/llms/huggingface/hub/models--MiniMaxAI--MiniMax-H3/snapshots/42ed227ee7df40d41602854ae760620d6eb651fe";
      extraArgs = "--root /var/llms/huggingface/gufo-h3-jobs --ttl 3600";
      supportImages = false;
    }
    {
      name = "gufo-qwen3-asr";
      provider = "gufo";
      modality = "asr";
      contextWindow = 1024; # --context
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen3-ASR-1.7B/snapshots/7278e1e70fe206f11671096ffdd38061171dd6e5";
      supportImages = false;
    }
    {
      name = "gufo-qwen3-asr-npu";
      provider = "gufo";
      modality = "asr";
      contextWindow = 1024;
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen3-ASR-1.7B/snapshots/7278e1e70fe206f11671096ffdd38061171dd6e5";
      extraArgs = "--npu";
    }
    {
      name = "gufo-qwen3-tts";
      provider = "gufo";
      modality = "tts";
      contextWindow = 4096; # --context
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen3-TTS-12Hz-1.7B-CustomVoice/snapshots/0c0e3051f131929182e2c023b9537f8b1c68adfe";
      supportImages = false;
    }
    {
      name = "gufo-qwen3-tts-npu";
      provider = "gufo";
      modality = "tts";
      contextWindow = 4096;
      modelPath = "/var/llms/huggingface/hub/models--Qwen--Qwen3-TTS-12Hz-1.7B-CustomVoice/snapshots/0c0e3051f131929182e2c023b9537f8b1c68adfe";
      extraArgs = "--npu";
    }
    # {
    #   name = "qwen3.5:0.8b";
    #   provider = "llama-server";
    #   contextWindow = 262144;
    #   huggingFace = "unsloth/Qwen3.5-0.8B-GGUF:UD-Q4_K_XL";
    #   extraArgs = "--temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.00 -ngl 999 --load-mode none -fa 1 --no-ui --kv-unified";
    #   supportImages = true;
    # }
    # {
    #   name = "qwen3.6:35b-MTP";
    #   provider = "llama-server";
    #   contextWindow = 262144;
    #   huggingFace = "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_XL";
    #   extraArgs = "--spec-type draft-mtp --spec-draft-n-max 3 --spec-draft-p-min 0.75 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --presence-penalty 0.0 --repeat-penalty 1.0 -ngl all --load-mode none -fa 1 --no-ui --kv-unified --ubatch-size 2048 --batch-size 4096 --chat-template-kwargs '{\"preserve_thinking\": true}'";
    #   supportImages = true;
    # }
    # {
    #   name = "qwen3.5:2b";
    #   provider = "flm";
    #   contextWindow = 262144;
    #   extraArgs = "--pmode turbo";
    #   supportImages = true;
    # }
  ];
}
