# node packages

npm packages wrapped for Nix with `buildNpmPackage`.

## Updating versions

```sh
bun run update.ts
bun run update.ts chrome-devtools-mcp@1.9.0
```

With no arguments, every package in `default.nix` is updated to the `latest` dist-tag, together with its `<pname>/package-lock.json`. With `<npmName>@<version>`, only that package is updated to that version. Several packages can be given at once.

Packages already at the target version are skipped. `--force` regenerates the hashes and `package-lock.json` even for the same version.

The script does not format or build. Run `just update-node-packages` from the repository root, or `nix fmt` and `nix flake check` afterwards.

### Constraints of update.ts

`update.ts` parses `default.nix` with regular expressions instead of evaluating it. It breaks if any of the following no longer hold.

- `default.nix` is nixfmt-formatted. Each `mkNpmPackage` block has attributes indented by 2 spaces, fields by 4 spaces, and closes with `  };`.
- `pname`, `version`, `hash`, and `npmDepsHash` are single-line string literals. `npmName` is optional and defaults to `pname`.
- `pname` contains only `A-Za-z0-9._+-`. For scoped packages, put the scoped name in `npmName` and the unscoped name in `pname`.
- Tarballs come from `https://registry.npmjs.org/<npmName>/-/<pname>-<version>.tgz`. The registry is fixed to npmjs.org through a temporary npmrc with `ignore-scripts=true`.
- `<npmName>@<version>` must be an exact version on the registry. Ranges and dist-tags are not accepted.
- Do not change the line endings of the generated `package-lock.json`. `npmDepsHash` is computed from its contents, so `nix build` fails with a hash mismatch otherwise. This is why git runs with `core.autocrlf = false` in `modules/home/git.nix`.
