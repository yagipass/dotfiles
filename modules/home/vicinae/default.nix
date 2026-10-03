{ pkgs, ... }:

{
  home.packages = [ pkgs.vicinae ];

  xdg.configFile."vicinae/settings.json" = {
    source = ./settings.json;
    force = true;
  };

  xdg.dataFile."vicinae/scripts/new-finder-window.sh" = {
    source = ./new-finder-window.sh;
    executable = true;
  };
}
