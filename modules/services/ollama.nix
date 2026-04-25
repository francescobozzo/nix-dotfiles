{ inputs, ... }:
{
  flake.modules.nixos.ollama =
    {
      config,
      pkgs,
      stdenv,
      ...
    }:
    {
      imports = [
        (inputs.nixpkgs-unstable + /nixos/modules/services/misc/ollama.nix)
      ];
      # nixpkgs.overlays = [
      #   (_: _: {
      #     ollama-rocm = pkgs.unstable.ollama-rocm;
      #   })
      # ];
      disabledModules = [
        "services/misc/ollama.nix"
      ];

      services.ollama = {
        enable = true;
        host = "0.0.0.0";
        port = 11434;
        package = pkgs.unstable.ollama-rocm;
        rocmOverrideGfx = "11.5.1";
        environmentVariables = {
          OLLAMA_NO_CLOUD = "1";
          OLLAMA_FLASH_ATTENTION = "1";
          OLLAMA_CONTEXT_LENGTH = "256000"; # max supported by qwen3-coder:30b
          # OLLAMA_KEEP_ALIVE = "-1"; # keep the model loaded
          # AMD_LOG_LEVEL = "3";
          # OLLAMA_ORIGINS = "*";
          # OLLAMA_DEBUG = "1";
          # HIP_VISIBLE_DEVICES = "1";
        };
      };

      services.open-webui = {
        enable = true;
        port = 9292;
        environment = {
          OLLAMA_BASE_URL = "http://localhost:${toString config.services.ollama.port}";
        };
        package = pkgs.unstable.open-webui;
      };
    };
}
