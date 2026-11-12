# jactionlint package

Builds [jactionlint](https://github.com/jdx/jactionlint) from source, starting from the derivation in nixpkgs. nixpkgs ships 2.4.0, whose tests fail on and after 2026-11-02 because a fixture still lists the retired `macos-14` runner labels. Once nixpkgs ships 2.5.0 or later, delete this directory and use `pkgs.jactionlint`.

## Updating the version

```sh
just update-jactionlint
```

This runs `nix-update` on the `jactionlint` flake package, which rewrites `version`, `hash`, and `vendorHash` in `package.nix` to the latest stable GitHub release, then formats and runs `nix flake check`.
