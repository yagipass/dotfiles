# jactionlint package

Builds [jactionlint](https://github.com/jdx/jactionlint) from source, based on the derivation in [NixOS/nixpkgs#572363](https://github.com/NixOS/nixpkgs/pull/572363). Once that PR lands, delete this directory and use `pkgs.jactionlint`.

## Updating the version

```sh
just update-jactionlint
```

This runs `nix-update` on the `jactionlint` flake package, which rewrites `version`, `hash`, and `vendorHash` in `package.nix` to the latest stable GitHub release, then formats and runs `nix flake check`.
