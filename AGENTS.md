# AGENTS.md

These instructions apply to the whole repository.

## Workflow

- Before changing anything, read the target, its direct callers, and shared values.
- State assumptions and success criteria. Ask when anything is unclear.
- Follow existing conventions and do not widen the requested scope.
- Do not hide unverified work, failures, or remaining tasks.

## Nix

After changing Nix files, run the following. `git add` new files first.

```sh
nix fmt
nix flake check
```

When changing the NixOS-WSL configuration from macOS, also run:

```sh
nix eval .#nixosConfigurations.wsl.config.system.build.toplevel.drvPath
```

Never run any `switch` command without an explicit request from the user. Changes that touch no Nix files do not need the validation above.

## Secrets

- Keep secrets and work-internal values out of the repository and the Nix store.
- Store values in 1Password. `templates/*.tpl` contain only `op://` references.
- From Nix, use runtime-generated files, includes, sourcing, or `WORK_*` environment variables. Evaluation and `switch` must succeed even when the generated files are absent.
- When changing a template or item schema, keep the README and every `op://` reference in sync.
- Never run `just secrets` without an explicit request from the user.
