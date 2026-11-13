# cccc package

Builds [cccc](https://github.com/moznion/cccc) from source. nixpkgs has an unrelated `pkgs.cccc` (C and C++ Code Counter), so this package is not listed in `.github/workflows/watch-nixpkgs.yml`. If nixpkgs ships moznion/cccc under another attribute, delete this directory and use that attribute.

## Updating the version

```sh
just update-cccc
```

This runs `nix-update` on the `cccc` flake package, which rewrites `version`, `hash`, and `cargoHash` in `package.nix` to the latest stable GitHub release, then formats and runs `nix flake check`.
