{ inputs, ... }:
{
  flake.modules.homeManager.ai-agents =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      directories = {
        antigravity-cli = ''"''${ANTIGRAVITY_CLI_CONFIG_DIR:-$HOME/.gemini/config}"'';
        codex = ''"''${CODEX_HOME:-$HOME/.codex}"'';
        claude = ''"''${CLAUDE_CONFIG_DIR:-$HOME/.claude}"'';
        opencode = ''"''${XDG_CONFIG_HOME:-$HOME/.config}/opencode"'';
        pi = ''"''${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/extensions"'';
        qodercli = ''"''${QODER_CONFIG_DIR:-$HOME/.qoder}"'';
      };
      herdr = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      options.fb.herdr.integrations = lib.mkOption {
        type = lib.types.listOf (lib.types.enum (builtins.attrNames directories));
        default = [ ];
        description = "Herdr agent integrations to install during activation.";
      };

      config = lib.mkIf (config.fb.herdr.integrations != [ ]) {
        home.packages = [ pkgs.python3 ];
        home.activation = lib.listToAttrs (
          map (agent: {
            name = "herdr-${agent}";
            value = lib.hm.dag.entryAfter [ "writeBoundary" "linkGeneration" ] ''
              $DRY_RUN_CMD mkdir -p ${directories.${agent}}
              ${
                if agent == "opencode" then
                  ''
                    if [ -z "$DRY_RUN_CMD" ] && [ -L ${directories.opencode}/tui.json ] && \
                      case "$(readlink ${directories.opencode}/tui.json)" in /nix/store/*) true ;; *) false ;; esac; then
                      (
                        tui=${directories.opencode}/tui.json
                        backup="$(mktemp "''${tui}.herdr.XXXXXXXX")"
                        rm "$backup"
                        mv "$tui" "$backup"
                        trap 'rm -f "$tui"; mv "$backup" "$tui"' EXIT
                        cp -L "$backup" "$tui"
                        chmod u+w "$tui"
                        ${herdr}/bin/herdr integration install opencode
                      )
                    else
                      $DRY_RUN_CMD ${herdr}/bin/herdr integration install opencode
                    fi
                  ''
                else
                  "$DRY_RUN_CMD ${herdr}/bin/herdr integration install ${agent}"
              }
            '';
          }) (lib.unique config.fb.herdr.integrations)
        );
      };
    };

  flake.modules.homeManager.dev =
    { pkgs, lib, ... }:
    let
      config = (pkgs.formats.toml { }).generate "herdr-config.toml" {
        onboarding = false;

        theme.name = "catppuccin";

        ui = {
          agent_panel_sort = "spaces";
          sound.enabled = false;
          toast.delivery = "off";
        };

        session.resume_agents_on_restore = true;

      };
    in
    {
      home.packages = [
        inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      xdg.configFile."herdr/config.toml".source = config;

    };
}
