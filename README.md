# Nix Darwin Configuration


## Install Nix

It is recommended to install Nix using the [Determinate installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer).

From the official documentation:

> It installs either Nix or Determinate Nix (with flakes enabled by default), it offers support for seamlessly uninstalling Nix, it enables Nix to survive macOS upgrades, and much more.


## Build the system

Run the following command to apply changes to the system:

```sh
cd /etc/nix-darwin/
sudo darwin-rebuild switch
```

## Update Nix Flake

Run the following command to update the `flake.lock` with the latest available software packages.

```sh
cd /etc/nix-darwin/
nix flake update
```

## Clean up unused resources

Particularly useful to free some space in the disk

```sh
nix-collect-garbage -d
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable)
- [Install from the Apple App Store](https://github.com/mas-cli/mas)
