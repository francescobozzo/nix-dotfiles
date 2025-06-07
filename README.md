# Nix Darwin Configuration


## Install Nix

It is recommended to install Nix using the [Determinate installer](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer).

From the official documentation:

> It installs either Nix or Determinate Nix (with flakes enabled by default), it offers support for seamlessly uninstalling Nix, it enables Nix to survive macOS upgrades, and much more.


## Build the system

Run the following command to apply changes to the system:

```sh
cd /etc/nix-darwin/
darwin-rebuild switch
```

## Update Nix Flake

Run the following command to update the `flake.lock` with the latest available software packages.

```sh
cd /etc/nix-darwin/
nix flake update
```

## Resources

- [Install VSCode and extensions with home manager](https://davi.wsh/blog/2024/11/nix-vscode/)
- [Install from the Apple App Store](https://github.com/mas-cli/mas)
