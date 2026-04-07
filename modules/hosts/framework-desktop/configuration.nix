{ inputs, self, ... }:
{
  flake.nixosConfigurations.neos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
      self.modules.nixos.fd
      self.modules.nixos.home-manager
    ];
  };

  flake.deploy.nodes.neos = {
    hostname = "neos";
    sshUser = "root";
    sudo = "doas -u";
    sshOpts = [ ];
    magicRollback = true;
    autoRollback = true;
    fastConnection = false;
    remoteBuild = true;
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.neos;
    };
  };

  # This is highly advised, and will prevent many possible mistakes
  flake.checks = builtins.mapAttrs (
    system: deployLib: deployLib.deployChecks self.deploy
  ) inputs.deploy-rs.lib;
}
