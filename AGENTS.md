# Nix Flake Configuration

`flake.nix` → imports `modules/` via `import-tree`. Auto-discovery.

Expose via reverse proxy: add `fb.services = [ { name, subdomain, port, category, icon, ... } ]` in the service's module (schema: `modules/services/fb-services.nix`, example: immich, glance).
