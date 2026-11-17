{
  config,
  lib,
  pkgs,
  ...
}:

let
  gh = lib.getExe config.programs.gh.package;
  git = lib.getExe config.programs.git.package;
in
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    config.global.warn_timeout = "0s";

    # Keep .direnv out of repositories by placing layout dirs under XDG cache.
    stdlib = ''
      : "''${XDG_CACHE_HOME:=$HOME/.cache}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
        local hash path
        echo "''${direnv_layout_dirs[$PWD]:=$(
          hash="$(${lib.getExe' pkgs.coreutils "sha1sum"} - <<<"$PWD")"
          hash="''${hash%%' '*}"
          path="''${PWD//[^a-zA-Z0-9]/-}"
          echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
        )}"
      }

      if [[ $PWD/ == "$HOME"/ghq/github.com/?*/* ]]; then
        gh_owner="''${PWD#"$HOME"/ghq/github.com/}"
        gh_owner="''${gh_owner%%/*}"
        gh_user="$(${git} config --get-urlmatch credential.username "https://github.com/$gh_owner/" 2>/dev/null)"
        if [[ -n $gh_user && $gh_user != "$(${gh} config get user --host github.com 2>/dev/null)" ]] &&
          ${gh} auth token --hostname github.com --user "$gh_user" >/dev/null 2>&1; then
          gh_config_dir="$XDG_CACHE_HOME/direnv/gh/$gh_user"
          mkdir -p "$gh_config_dir"
          ln -sf "''${XDG_CONFIG_HOME:-$HOME/.config}/gh/config.yml" "$gh_config_dir/config.yml"
          printf 'github.com:\n    users:\n        %s:\n    user: %s\n' "$gh_user" "$gh_user" >"$gh_config_dir/hosts.yml"
          export GH_CONFIG_DIR="$gh_config_dir"
        fi
        unset gh_owner gh_user gh_config_dir
      fi
    '';
  };
}
