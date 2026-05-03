{ inputs, ... }:
{
  flake.modules.nixos.ollama =
    {
      config,
      pkgs,
      stdenv,
      lib,
      ...
    }:
    let
      llama-cpp = pkgs.unstable.llama-cpp-rocm;
      llama-server = lib.getExe' llama-cpp "llama-server";
      llmGroup = "llm";
      llmPath = "/var/llms";
    in
    {
      imports = [
        (inputs.nixpkgs-unstable + /nixos/modules/services/misc/ollama.nix)
      ];
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

      services.llama-swap = {
        enable = true;
        port = 11435;
        settings = {
          # increase health check timeout to 1 hour to accommodate large model downloads
          healthCheckTimeout = 3600;
          models = {
            "qwen3.6:27b" = {
              cmd = "${llama-server} --port \${PORT} -hf unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.00 -ngl 999 --no-mmap -fa 1 --no-webui --kv-unified -c 262144";
              aliases = [ "qwen3.6:27b" ];
              # ttl = 300; # 5 minutes
            };
            "qwen3.5:0.8b" = {
              cmd = "${llama-server} --port \${PORT} -hf unsloth/Qwen3.5-0.8B-GGUF:UD-Q4_K_XL --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.00 -ngl 999 --no-mmap -fa 1 --no-webui --kv-unified -c 262144";
              aliases = [ "qwen3.5:0.8b" ];
              # ttl = 300; # 5 minutes
            };
          };
        };
      };

      users.groups.${llmGroup} = { };
      users.users.fbozzo.extraGroups = [ llmGroup ]; # required for llama-bench

      environment.sessionVariables.HF_HOME = "${llmPath}/huggingface";
      systemd.tmpfiles.rules = [
        "d ${llmPath} 2770 ${config.users.users.fbozzo.name} ${llmGroup} - -"
        "a+ ${llmPath} - - - - default:group:${llmGroup}:rwx"
        "a+ ${llmPath} - - - - default:group::rwx"
      ];

      systemd.services.llama-swap = {
        environment = {
          XDG_CACHE_HOME = "/var/cache/llama.cpp";
          HF_HOME = config.environment.sessionVariables.HF_HOME;
        };
        serviceConfig = {
          CacheDirectory = "llama.cpp";
          DynamicUser = lib.mkForce false;
          User = "llama-swap";
          Group = llmGroup;
          BindPaths = [ llmPath ];
        };
      };
      users.users.llama-swap = {
        isSystemUser = true;
        group = llmGroup;
        description = "llama-swap service user";
      };

      environment.systemPackages = [
        llama-cpp
        pkgs.unstable.python3Packages.huggingface-hub
      ];
    };
}
