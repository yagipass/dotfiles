set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

home_config := env("HOME_CONFIG", "default")
darwin_config := env("DARWIN_CONFIG", "macos")
nixos_config := env("NIXOS_CONFIG", "wsl")

host := if os() == "macos" {
  "macos"
} else if os() == "linux" {
  "wsl"
} else {
  "unsupported"
}

# List available recipes.
default:
  @just --list

# Update platform-specific inputs and run validation.
update:
  @just update-{{host}}

# Update every input regardless of host (used by CI).
update-all: update-flake _update-node-packages _update-jmc fmt

# Update flake.lock only.
update-flake:
  nix flake update

# Update Nix-wrapped node packages.
update-node-packages: _update-node-packages fmt lint

# Update Nix-wrapped JDK Mission Control.
update-jmc: _update-jmc fmt lint

[private]
update-macos: _update-node-packages update-flake fmt lint

[private]
update-wsl: update-flake fmt lint

[private]
update-unsupported:
  @echo "unsupported OS: {{os()}}" >&2
  @exit 1

[private]
[working-directory("packages/node")]
_update-node-packages:
  bun run update.ts

[private]
[working-directory("packages/jdk-mission-control")]
_update-jmc:
  bun run update.ts

# Format the repository.
fmt:
  nix fmt

# Run flake checks.
lint:
  nix flake check

# Build platform-specific outputs.
build:
  @just build-{{host}}

[private]
build-macos: build-node-packages build-home build-darwin

[private]
build-wsl:
  nh os build . -H {{nixos_config}}

[private]
build-unsupported:
  @echo "unsupported OS: {{os()}}" >&2
  @exit 1

# Build Home Manager activation package.
build-home:
  nh home build . -c {{home_config}}

# Build nix-darwin system.
build-darwin:
  nh darwin build . -H {{darwin_config}}

# Build Nix-wrapped node packages.
build-node-packages:
  nix build .#chrome-devtools-mcp

# Apply platform-specific system configuration.
switch:
  @just switch-{{host}}

[private]
switch-macos: switch-darwin switch-home

[private]
switch-wsl:
  nh os switch . -H {{nixos_config}}

[private]
switch-unsupported:
  @echo "unsupported OS: {{os()}}" >&2
  @exit 1

# Apply Home Manager configuration.
switch-home:
  nh home switch . -c {{home_config}}

# Apply nix-darwin system configuration.
switch-darwin:
  nh darwin switch . -H {{darwin_config}}

# Render config files from 1Password.
secrets:
  #!/usr/bin/env bash
  set -euo pipefail
  umask 077
  config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  tmp=""
  trap '[[ -n "$tmp" ]] && rm -f "$tmp"' EXIT
  render() {
    local template="templates/$1" target="$2"
    mkdir -p "$(dirname "$target")"
    tmp="$(mktemp "$target.XXXXXX")"
    op inject --in-file "$template" > "$tmp"
    chmod 0600 "$tmp"
    mv "$tmp" "$target"
    tmp=""
    echo "rendered $target"
  }
  render git-profiles.inc.tpl "$config_home/git/profiles.inc"
  render git-work.inc.tpl "$config_home/git/work.inc"
  render git-personal.inc.tpl "$config_home/git/personal.inc"
  render work.zsh.tpl "$config_home/zsh/work.zsh"
  render maven-settings.xml.tpl "$HOME/.m2/settings.xml"
  render work.gradle.tpl "$HOME/.gradle/init.d/work.gradle"

# Delete old Nix generations and unused store paths.
gc:
  nh clean all
