{
  flake.modules.darwin.macbook-pro =
    { config, pkgs, ... }:
    let
      username = config.system.primaryUser;
    in
    {
      environment = {
        systemPackages = [
          pkgs.monitorcontrol
        ];
        variables = {
          "LESS" = "-R";
          "EDITOR" = "zeditor --wait";

          # Claude
          "ANTHROPIC_AUTH_TOKEN" = "ollama";
          "ANTHROPIC_API_KEY" = "";
          "ANTHROPIC_BASE_URL" = "https://llm.fbozzo.dpdns.org";
        };
        shellAliases = {
          # https://github.com/ironicbadger/nix-config/blob/3aaa2cfb4dfa2299986ef5298b39286cc23c60f1/data/mac-dot-zshrc#L50
          tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
        };
      };

      # Use Tailscale's App Store version to create a new network device with local dns override.
      # The open source one through nix pkgs requires a dns override, which could be implemented by
      # running networksetup -setdnsservers to all network devices (`networksetup -listallnetworkservices`):
      # - at `tailscale up` you should set the 100.100.100.100 Tailscale magic dns as the only resolver.
      # - at `tailscale down` you should set an empty resolver list to use the local network's DNS server.
      # References:
      # - https://tailscale.com/kb/1065/macos-variants
      # - https://github.com/nix-darwin/nix-darwin/blob/master/modules/networking/default.nix#L19
      # - https://github.com/nix-darwin/nix-darwin/blob/c31afa6e76da9bbc7c9295e39c7de9fca1071ea1/modules/services/tailscale.nix#L64
      services.tailscale = {
        enable = false;
        overrideLocalDns = false;
      };

      # user
      programs.zsh.enable = true;
      users.users.${username} = {
        home = "/Users/${username}";
        shell = pkgs.zsh;
      };
    };
}
