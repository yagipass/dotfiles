{ pkgs, ... }:

{
  home.packages = [ pkgs.vicinae ];

  xdg.configFile."vicinae/settings.json" = {
    source = ./settings.json;
    force = true;
  };
}
