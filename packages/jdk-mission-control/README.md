# jdk-mission-control package

Wraps JDK Mission Control, which is not in nixpkgs, from the official macOS/aarch64 binary. The JVM is the Nix `zulu21`. macOS/aarch64 only.

## Updating the version

```sh
bun run update.ts
bun run update.ts --force
```

`update.ts` follows <https://jdk.java.net/jmc/> to the latest major, finds the macOS/aarch64 tarball, and rewrites `version`, `build`, and `hash` in `package.nix`. `hash` comes from `nix store prefetch-file`. `major` and `homepage` are derived from `version`.

The script does not format or build. Run `just update-jmc` from the repository root, or `nix fmt` and `nix flake check` afterwards.

If the current version and build already match the latest, or the latest is older than the current, the update is skipped. `--force` rewrites anyway.

### Constraints of update.ts

`update.ts` parses `package.nix` with regular expressions instead of evaluating it. It breaks if any of the following no longer hold.

- `package.nix` is nixfmt-formatted. `version`, `build`, and `hash` are each a single-line string literal that appears exactly once.
- The download URL has the form `https://download.java.net/java/GA/jmc<major>/<build>/binaries/jmc-<version>_macos-aarch64.tar.gz`.
- The target is always the latest build of the latest major. jdk.java.net only publishes the latest per major, so no other version can be chosen.
- Only macOS/aarch64 is packaged.
