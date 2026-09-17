{ lib, pkgs, ... }:

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
    '';
  };
}
