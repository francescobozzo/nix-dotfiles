# Nix Flake Configuration

`flake.nix` → imports `modules/` via `import-tree`. Auto-discovery.

## Pi Agent

### Extensions

Fetch sources with `pkgs.fetchFromGitHub` (hash: start empty, build, copy from error, rebuild).
Extensions with npm dependencies need `pkgs.buildNpmPackage` instead — see upstream examples.

Discovered in `~/.pi/agent/extensions/`. Rules:

- `*.ts`/`*.js` in root → auto-loaded
- Subfolders need `index.ts`, `index.js`, or `package.json` with `pi.extensions`
- No recursion beyond one level

**Single-file extension:**

```nix
home.file.".pi/agent/extensions/name.ts" = {
  source = src + "/path/to/file.ts";
};
```

**Multi-file extension (no index.ts upstream):**

```nix
ext = pkgs.stdenv.mkDerivation {
  name = "pi-ext"; src = fetchedSource + "/ext";
  installPhase = ''
    mkdir -p $out && cp -r $src/* $out/
    echo 'export { default } from "./main.js";' > $out/index.ts
  '';
};
home.file.".pi/agent/extensions/ext" = { source = ext; recursive = true; };
```
