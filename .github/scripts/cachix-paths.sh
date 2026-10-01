#!/usr/bin/env bash
set -euo pipefail

cache=$1
system=$(nix eval --raw --impure --expr builtins.currentSystem)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

nix eval --json ".#checks.$system" --apply builtins.attrNames |
  jq -r --arg system "$system" '.[] | ".#checks.\($system).\(.)"' |
  xargs nix build --no-link --print-out-paths |
  xargs nix path-info --recursive | sort -u >"$tmp/closure"

served_by() {
  xargs -r nix path-info --store "$1" --json --json-format 1 <"$2" \
    2> >(grep -v -e "^don't know how to build these paths:" -e '^  /nix/store/' >&2) |
    jq -r 'to_entries[] | select(.value != null) | .key' | sort -u >"$3"
}

served_by https://cache.nixos.org "$tmp/closure" "$tmp/upstream"
comm -23 "$tmp/closure" "$tmp/upstream" >"$tmp/candidates"

grep -E '^/nix/store/[a-z0-9]{32}-1password-cli-' "$tmp/candidates" >"$tmp/blocked" || true
for store in $(nix config show substituters); do
  case $store in
  https://cache.nixos.org* | "https://$cache.cachix.org"*) continue ;;
  esac
  served_by "$store" "$tmp/candidates" "$tmp/served"
  cat "$tmp/served" >>"$tmp/blocked"
done

xargs -r nix-store --query --referrers-closure <"$tmp/blocked" | sort -u >"$tmp/excluded"
comm -23 "$tmp/candidates" "$tmp/excluded"
