{ pkgs, ... }:

{
  home.packages = [ (import ../../packages/node { inherit pkgs; }).chrome-devtools-mcp ];

  xdg.configFile."cd4a/config.json".text = builtins.toJSON {
    usageStatistics = false;
  };
}
