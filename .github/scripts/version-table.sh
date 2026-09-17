package_versions() {
  local apply='ps: map (p: { name = p.pname or p.name; version = p.version or null; }) ps'
  {
    nix eval --json .#homeConfigurations.default.config.home.packages --apply "$apply"
    nix eval --json .#nixosConfigurations.wsl.config.home-manager.users.nixos.home.packages --apply "$apply"
  } | jq -sc 'add | map(select(.version != null)) | unique_by(.name)'
}

input_rows() {
  jq -rn --slurpfile before "$1" --slurpfile after "$2" '
    def revs: .nodes as $nodes | $nodes.root.inputs | with_entries(.value |= ($nodes[.].locked.rev // $nodes[.].locked.narHash));
    ($before[0] | revs) as $old
    | ($after[0] | revs) as $new
    | $new | to_entries[]
    | select($old[.key] != .value)
    | "| \(.key) | `\($old[.key] // "N/A" | .[0:7])` | `\(.value | .[0:7])` |"
  '
}

package_rows() {
  jq -rn --argjson before "$1" --argjson after "$2" '
    ($before | map({(.name): .version}) | add // {}) as $old
    | $after[]
    | select($old[.name] != .version)
    | "| \(.name) | `\($old[.name] // "N/A")` | `\(.version)` |"
  '
}

version_body() {
  echo "$1"
  echo
  echo "## Flake Inputs"
  echo
  if [ -z "$2" ]; then
    echo "No flake input changed."
  else
    echo "| Input | Old | New |"
    echo "|-------|-----|-----|"
    printf '%s\n' "$2"
  fi
  echo
  echo "## Package Versions"
  echo
  if [ -z "$3" ]; then
    echo "Flake inputs were updated, but no package version changed."
  else
    echo "| Package | Old | New |"
    echo "|---------|-----|-----|"
    printf '%s\n' "$3"
  fi
}
