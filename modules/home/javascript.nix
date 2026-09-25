{ config, ... }:

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
  programs.npm = {
    enable = true;

    settings = {
      inherit registry;
      ignore-scripts = true;
      min-release-age = minReleaseDays;
      cache = "${config.xdg.cacheHome}/npm";
    };
  };

  programs.bun = {
    enable = true;

    settings.install = {
      inherit registry;
      minimumReleaseAge = minReleaseDays * 24 * 60 * 60;
      cache.dir = "${config.xdg.cacheHome}/bun";
    };
  };

  home.sessionVariables.BUN_INSTALL = bunInstall;
  home.sessionPath = [ "${bunInstall}/bin" ];
}
