{ inputs, self, ... }:
{
  flake.darwinConfigurations."MBP-M4-Pro" = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      self.modules.darwin.macbook-pro
      self.modules.darwin.home-manager
      inputs.mac-app-util.darwinModules.default
    ];
  };
}
