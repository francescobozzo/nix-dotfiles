{ inputs, ... }:
{
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
