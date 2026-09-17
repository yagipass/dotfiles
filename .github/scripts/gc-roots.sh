set -euo pipefail

mkdir -p "$RUNNER_TEMP/gc-roots"
system=$(nix eval --raw --impure --expr builtins.currentSystem)
{
  nix flake archive --json | jq -r '.. | .path? // empty'
  nix eval --json ".#checks.$system" --apply builtins.attrNames |
    jq -r --arg system "$system" '.[] | ".#checks.\($system).\(.)"'
} | xargs nix build --out-link "$RUNNER_TEMP/gc-roots/result"
