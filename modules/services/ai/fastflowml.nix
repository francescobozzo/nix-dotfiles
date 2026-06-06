{ inputs, ... }:
{
  flake.modules.nixos.ai =
    { config, ... }:
    {
      imports = [ inputs.nix-amd-ai.nixosModules.default ];

      hardware.amd-npu = {
        enable = true;
        enableNPU = true; # default; set false for GPU-only hosts (see "Other hardware")
        enableFastFlowLM = true; # LLM inference on NPU (requires enableNPU)
        enableLemonade = false; # OpenAI-compatible API server
        enableROCm = false; # ROCm GPU backends (llamacpp + sd-cpp)
        enableVulkan = false; # Vulkan GPU backends (llamacpp + whispercpp)
        enableImageGen = false; # default true; set false to drop sd-cpp from closure
        lemonade.user = "fbozzo";
      };

      users.users.fbozzo.extraGroups = [
        "video"
        "render"
      ];
    };
}
