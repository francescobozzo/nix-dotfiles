# Nix Configuration

This repository contains the setup of my personal devices through Nix, including:
- MacBook Pro M4 Pro (Nix Darwin)
- Framework Desktop (NixOS)

## NixOS

### Installation

In case you need to generate the hardware configuration:
```sh
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/framework-desktop/hardware-configuration.nix --flake .#neos --target-host nixos@192.168.1.89
```

In case you want to use the existing hardware configuration
```sh
nix run github:nix-community/nixos-anywhere -- --flake .#neos --target-host nixos@192.168.1.89
```

### Deployment

Use `deploy-rs` to deploy changes remotely:

```sh
deploy --skip-checks .#neos
```

### Resources

- https://nixos.org/manual/nixos/stable/#sec-installation-manual
- https://github.com/nix-community/nixos-anywhere
- https://github.com/serokell/deploy-rs


## MacOS

### Install Nix

It is recommended to install Nix using the [Determinate installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer).

From the official documentation:

> It installs either Nix or Determinate Nix (with flakes enabled by default), it offers support for seamlessly uninstalling Nix, it enables Nix to survive macOS upgrades, and much more.


### Build the system

Run the following command to apply changes to the system:

```sh
cd /etc/nix-darwin/
sudo darwin-rebuild switch
```

### Update Nix Flake

Run the following command to update the `flake.lock` with the latest available software packages.

```sh
cd /etc/nix-darwin/
nix flake update
```

### Clean up unused resources

Particularly useful to free some space in the disk

```sh
nix-collect-garbage -d
```

### Project folder

When initializing a new project using nix flakes, use the following command to start with a template.

```sh
nix flake new -t github:nix-community/nix-direnv .
```

### Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable)
- [Install from the Apple App Store](https://github.com/mas-cli/mas)
