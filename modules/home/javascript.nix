{ config, lib, ... }:

let
  registries = {
    npmjs = "https://registry.npmjs.org/";
    flatt = "https://npm.flatt.tech";
  };
  registry = registries.flatt;
  minReleaseDays = 7;
  bunInstall = "${config.xdg.dataHome}/bun";
in
{
  programs = {
    npm = {
      enable = true;

      settings = {
        inherit registry;
        ignore-scripts = true;
        min-release-age = minReleaseDays;
        cache = "${config.xdg.cacheHome}/npm";
      };
    };

    bun = {
      enable = true;

      settings.install = {
        inherit registry;
        minimumReleaseAge = minReleaseDays * 24 * 60 * 60;
        cache.dir = "${config.xdg.cacheHome}/bun";
      };
    };

    pnpm.enable = true;

    zsh.initContent = lib.mkAfter ''
      _work_npm_registry() {
        [[ -n "$WORK_NPM_REGISTRY" && -n "$WORK_GIT_DOMAIN" ]] || return 0
        if [[ "$PWD/" == "$HOME/ghq/$WORK_GIT_DOMAIN/"* ]]; then
          export npm_config_registry="$WORK_NPM_REGISTRY" pnpm_config_registry="$WORK_NPM_REGISTRY"
        else
          [[ "$npm_config_registry" == "$WORK_NPM_REGISTRY" ]] && unset npm_config_registry
          [[ "$pnpm_config_registry" == "$WORK_NPM_REGISTRY" ]] && unset pnpm_config_registry
        fi
        return 0
      }
      autoload -Uz add-zsh-hook
      add-zsh-hook chpwd _work_npm_registry
      _work_npm_registry
    '';
  };

  xdg.configFile."pnpm/config.yaml".text = ''
    minimumReleaseAge: ${toString (minReleaseDays * 24 * 60)}
  '';

  home.sessionVariables.BUN_INSTALL = bunInstall;
  home.sessionPath = [ "${bunInstall}/bin" ];
}
