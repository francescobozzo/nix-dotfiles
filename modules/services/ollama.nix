{ inputs, self, ... }:
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
      llama-cpp =
        (pkgs.unstable.llama-cpp.override {
          rocmSupport = true;
          rocmGpuTargets = [ "gfx1151" ];
        }).overrideAttrs
          (oldAttrs: rec {
            version = "9186";
            src = pkgs.fetchFromGitHub {
              owner = "ggml-org";
              repo = "llama.cpp";
              tag = "b${version}";
              hash = "sha256-mkdZl/yReMMbls6neFmyD5gOZYR2wsafipxlRXcDPYM=";
              leaveDotGit = true;
              postFetch = ''
                git -C "$out" rev-parse --short HEAD > $out/COMMIT
                find "$out" -name .git -print0 | xargs -0 rm -rf
              '';
            };
            npmRoot = "tools/ui";
            npmDepsHash = "sha256-WaEePrEZ7O/7deP2KJhe0AwiSKYA8HOqETmMHUkmBe0=";

            cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
              "-DLLAMA_HIP_UMA=ON" # unified memory
            ];

            # Mirror the Strix Halo toolbox HIP tuning: pin the ROCm path explicitly and
            # raise the local unroll threshold for gfx1151 kernels.
            cmakeFlagsArray = (oldAttrs.cmakeFlagsArray or [ ]) ++ [
              "-DCMAKE_HIP_FLAGS=--rocm-path=${pkgs.rocmPackages.clr} -mllvm --amdgpu-unroll-threshold-local=600"
            ];
          });
      llama-server = lib.getExe' llama-cpp "llama-server";
      llmGroup = "llm";
      llmPath = "/var/llms";
      llamaModels = lib.filter (m: m.provider == "llama") self.llms;
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
          models = lib.listToAttrs (
            builtins.map (m: {
              name = m.name;
              value = {
                cmd = "${llama-server} --port \${PORT} -hf ${m.huggingFace} ${m.llamaArgs}";
                aliases = [ m.name ];
              };
            }) llamaModels
          );
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
