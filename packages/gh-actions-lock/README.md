# gh-actions-lock package

Builds the [gh-actions-lock](https://github.com/github/gh-actions-lock) GitHub CLI extension from source, based on the derivation in [NixOS/nixpkgs#568617](https://github.com/NixOS/nixpkgs/pull/568617). Once that PR lands, delete this directory and use `pkgs.gh-actions-lock`.

## Updating the version

```sh
just update-gh-actions-lock
```

This runs `nix-update` on the `gh-actions-lock` flake package, which rewrites `version`, `hash`, and `vendorHash` in `package.nix` to the latest stable GitHub release, then formats and runs `nix flake check`.
