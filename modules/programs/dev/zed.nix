{ self, ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, lib, ... }:
    let
      ollamaModels = builtins.map (m: {
        name = m.name;
        display_name = m.name;
        max_tokens = 32768;
        keep_alive = "5m";
        supports_tools = true;
        supports_thinking = true;
        supports_images = m.supportImages;
      }) (lib.filter (m: m.provider == "ollama") self.llms);

      # openai_compatible uses nested "capabilities" block
      llamaModels = builtins.map (m: {
        name = m.name;
        display_name = m.name;
        max_tokens = 32768;
        capabilities = {
          tools = true;
          images = m.supportImages;
          parallel_tool_calls = false;
          prompt_cache_key = false;
        };
      }) (lib.filter (m: m.provider == "llama") self.llms);
    in
    {
      home.packages = with pkgs; [
        nixfmt
        nil
      ];

      programs.zsh.sessionVariables."EDITOR" = "zeditor --wait";
      programs.delta.options.hyperlinks-file-link-format = "zed://file/{path}:{line}";

      programs.zed-editor = {
        enable = true;
        extensions = [
          "basher"
          "catppuccin"
          "catppuccin-icons"
          "docker-compose"
          "dockerfile"
          "env" # .env and conf file
          "git-firefly"
          "nix"
          "toml"
          "ruff"
          "rust"
          "sql"
          "svelte"
          "toml"
          "make"
        ];
        userSettings = {
          icon_theme = "Catppuccin Macchiato";
          theme = {
            mode = "system";
            dark = "Catppuccin Macchiato";
            light = "Catppuccin Latte";
          };
          journal.hour_format = "hour24";
          vim_mode = false;

          format_on_save = "on";
          autosave = {
            after_delay = {
              milliseconds = 1000;
            };
          };

          auto_update = false;
          load_direnv = "shell_hook";
          tabs = {
            file_icons = true;
            git_status = true;
          };

          double_click_in_multibuffer = "open";

          telemetry = {
            diagnostics = false;
            metrics = false;
          };

          lsp = {
            pylsp = {
              binary.path_lookup = true;
            };
            ruff = {
              initialization_options = {
                settings = {
                  lineLength = 120;
                };
              };
            };
            nil = {
              binary.path = "nil";
              initialization_options = {
                formatting.command = [ "nixfmt" ];
              };
            };
            vtsls = {
              settings = {
                typescript = {
                  tsserver = {
                    maxTsServerMemory = 16184;
                  };
                };
              };
            };
          };

          # languages
          languages = {
            Python = {
              language_servers = [
                "!ty"
                "basedpyright"
                "..."
              ];
              format_on_save = "on";
              code_actions_on_format = {
                "source.fixAll.ruff" = true;
                "source.organizeImports.ruff" = true;
              };
              formatter.language_server.name = "ruff";
            };
            Nix = {
              language_servers = [
                "nil"
                "!nixd"
                "..."
              ];
            };
          };

          show_edit_predictions = false;
          language_models = {
            ollama = {
              api_url = "https://llm.fbozzo.dpdns.org";
              available_models = ollamaModels;
            };
            openai_compatible.llama = {
              api_url = "https://llama.fbozzo.dpdns.org/v1";
              available_models = llamaModels;
            };
          };
        };
      };
    };
}
