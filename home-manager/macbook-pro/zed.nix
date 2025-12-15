{
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
    ];
    userSettings = {
      icon_theme = "Catppuccin Macchiato";
      theme = {
        mode = "system";
        dark = "Catppuccin Macchiato";
        light = "Catppuccin Latte";
      };
      hour_format = "hour24";
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
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
        };
        package-version-server = {
          binary = {
            path_lookup = true;
          };
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
            "ty"
            "!basedpyright"
            "..."
          ];
          format_on_save = "on";
          formatter = [
            {
              language_server = {
                name = "ruff";
              };
            }
            {
              code_actions = {
                "source.fixAll.ruff" = true;
                "source.organizeImports.ruff" = true;
              };
            }
          ];
        };
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
            "..."
          ];
        };
      };
    };
  };
}
