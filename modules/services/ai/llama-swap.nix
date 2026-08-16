{ inputs, self, ... }:
{
  flake.modules.nixos.ai =
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
            version = "10173";
            src = pkgs.fetchFromGitHub {
              owner = "ggml-org";
              repo = "llama.cpp";
              tag = "b${version}";
              hash = "sha256-nXpeGrPupPFkrsAyRU/a8MUUAmcdt3jJZcMh5mKA5JA=";
              leaveDotGit = true;
              postFetch = ''
                git -C "$out" rev-parse --short HEAD > $out/COMMIT
                find "$out" -name .git -print0 | xargs -0 rm -rf
              '';
            };
            npmRoot = "tools/ui";
            npmDepsHash = "sha256-B7uEynAG70a3xauBKc20RuFa9cnWaWzVBCh+LPLBnIM=";

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
      ds4 = inputs.ds4.packages.${pkgs.stdenv.hostPlatform.system}.default;
      ds4-server = lib.getExe' ds4 "ds4-server";
      vllm = inputs.nix-amd-ai.packages.${pkgs.stdenv.hostPlatform.system}.vllm-rocm.override {
        gpuTarget = "gfx1151";
      };
      llmGroup = "llm";
      llmPath = "/var/llms";
      llamaModels = lib.filter (m: m.provider == "llama-server") self.llms;
      ds4Models = lib.filter (m: m.provider == "ds4-server") self.llms;
      flmModels = lib.filter (m: m.provider == "flm") self.llms;
    in
    {
      services.llama-swap = {
        enable = true;
        port = 11435;
        package = pkgs.unstable.llama-swap;
        settings = {
          healthCheckTimeout = 3600; # increase health check timeout to 1 hour to accommodate large model downloads
          sendLoadingState = true;

          peers.openrouter = {
            proxy = "https://openrouter.ai/api";
            apiKey = "\${env.OPENROUTER_KEY}";
            models = map (m: m.name) (lib.filter (m: m.provider == "openrouter") self.llms);

            # https://openrouter.ai/docs/guides/features/zdr
            # filters.setParams.provider = {
            #   data_collection = "deny";
            #   zdr = true;
            # };
          };

          models =
            lib.listToAttrs (
              builtins.map (m: {
                name = m.name;
                value = {
                  cmd = "${llama-server} --port \${PORT} -hf ${m.huggingFace} -c ${toString m.contextWindow} ${m.llamaArgs}";
                  aliases = [ m.name ];
                };
              }) llamaModels
            )
            // lib.listToAttrs (
              builtins.map (m: {
                name = m.name;
                value = {
                  cmd = "${ds4-server} --port \${PORT} --ctx ${toString m.contextWindow} ${m.llamaArgs}";
                  aliases = [ m.name ];
                  checkEndpoint = "/v1/models";
                  timeouts = {
                    responseHeader = 600;
                  };
                };
              }) ds4Models
            )
            // lib.listToAttrs (
              builtins.map (m: {
                name = m.name;
                value = {
                  cmd = "${pkgs.fastflowlm}/bin/flm serve --port \${PORT} -c ${toString m.contextWindow} ${m.llamaArgs}";
                  aliases = [ m.name ];
                  checkEndpoint = "/v1/models";
                };
              }) flmModels
            );
        };
      };

      fb.services = [
        {
          name = "llama";
          port = config.services.llama-swap.port;
          gatusHealthcheckEndpoint = "/health";
          category = "ai";
          icon = "mdi:swap-horizontal";
          extraGatusConditions = [
            "[BODY] == OK"
          ];
        }
      ];

      users.groups.${llmGroup} = { };
      users.users.fbozzo.extraGroups = [ llmGroup ]; # required for llama-bench

      environment.sessionVariables.HF_HOME = "${llmPath}/huggingface";
      environment.sessionVariables.FLM_MODEL_PATH = "${llmPath}/flm";

      systemd.tmpfiles.rules = [
        "d ${llmPath} 2770 ${config.users.users.fbozzo.name} ${llmGroup} - -"
        "a+ ${llmPath} - - - - default:group:${llmGroup}:rwx"
        "a+ ${llmPath} - - - - default:group::rwx"
      ];

      systemd.services.llama-swap = {
        environment = {
          XDG_CACHE_HOME = "/var/cache/llama.cpp";
          HF_HOME = config.environment.sessionVariables.HF_HOME;

          # fastflowlm with npu support
          FLM_MODEL_PATH = config.environment.sessionVariables.FLM_MODEL_PATH;
          XILINX_XRT = config.environment.sessionVariables.XILINX_XRT or "";
          XRT_PATH = config.environment.sessionVariables.XRT_PATH or "";
          FLM_DISABLE_UPDATE_CHECK = "1";
          LD_LIBRARY_PATH = "${config.environment.sessionVariables.XILINX_XRT or ""}/lib";
        };
        serviceConfig = {
          CacheDirectory = "llama.cpp";
          DynamicUser = lib.mkForce false;
          User = "llama-swap";
          Group = llmGroup;
          BindPaths = [ llmPath ];
          LimitMEMLOCK = "infinity"; # fastflowlm with npu support
          EnvironmentFile = [ config.sops.secrets."llama-swap-env".path ];
        };
      };
      users.users.llama-swap = {
        isSystemUser = true;
        group = llmGroup;
        description = "llama-swap service user";
        extraGroups = [
          "video"
          "render"
        ];
      };

      sops.secrets."llama-swap-env" = {
        restartUnits = [ "llama-swap.service" ];
      };

      environment.systemPackages = [
        llama-cpp
        ds4
        pkgs.unstable.python314Packages.huggingface-hub
        vllm
      ];
    };
}
