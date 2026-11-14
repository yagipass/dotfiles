# caddy package

Builds Caddy from nixpkgs with the [Cloudflare DNS plugin](https://github.com/caddy-dns/cloudflare) for `modules/darwin/caddy`. nixpkgs already has `pkgs.caddy`, so this package is not listed in `.github/workflows/watch-nixpkgs.yml`.

Only macOS uses it, and only `checks.aarch64-darwin` builds it. The flake also exposes it on x86_64-linux so that `just update-all`, which runs on Ubuntu in CI, can compute `hash`.

## Updating

```sh
just update-caddy
```

This runs `nix-update` on the `caddy` flake package, which rewrites `hash` in `package.nix` for the Caddy version in the locked nixpkgs, then formats and runs `nix flake check`. `just update` on macOS and `just update-all` run it after `nix flake update`. To change the plugin version, edit its tag in `plugins` first.
