{ inputs, self, ... }:
{
  flake.modules.nixos.ai =
    {
      config,
      pkgs,
      fbLlamaCpp,
      lib,
      ...
    }:
    let
      llama-server = lib.getExe' fbLlamaCpp "llama-server";
      llmGroup = "llm";
      llmPath = "/var/llms";
      llamaModels = lib.filter (m: m.provider == "llama-server") self.llms;
      flmModels = lib.filter (m: m.provider == "flm") self.llms;
      gufoModels = lib.filter (m: m.provider == "gufo") self.llms;
      gufo = inputs.gufo.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Build the gufo serve command line via gufo's mkGufoServe. llama-swap
      # passes the listen port through the PORT env var; mkGufoServe supports
      # raw "$VAR" env references for --port. mkGufoServe covers all gufo
      # modalities (llm/image/video/embedding/tts/asr); extra flags (speculative,
      # video --root/--ttl) ride on m.llamaArgs.
      mkGufoCmd =
        m:
        inputs.gufo.lib.mkGufoServe {
          system = pkgs.stdenv.hostPlatform.system;
          inherit gufo;
          modality = if m.modality == null then "llm" else m.modality;
          model = m.modelPath;
          servedModelName = m.name;
          context = m.contextWindow;
          port = "\${PORT}";
        }
        + (if m.llamaArgs == "" then "" else " " + m.llamaArgs);
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
                  cmd = "${pkgs.fastflowlm}/bin/flm serve --port \${PORT} -c ${toString m.contextWindow} ${m.llamaArgs}";
                  aliases = [ m.name ];
                  checkEndpoint = "/v1/models";
                };
              }) flmModels
            )
            // lib.listToAttrs (
              builtins.map (m: {
                name = m.name;
                value = {
                  cmd = mkGufoCmd m;
                  aliases = [ m.name ];
                  checkEndpoint = "/v1/models";
                  timeouts = {
                    responseHeader = 600;
                  };
                };
              }) gufoModels
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
        fbLlamaCpp
        gufo
        pkgs.unstable.python314Packages.huggingface-hub
      ];
    };
}
