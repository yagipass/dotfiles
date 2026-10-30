{ pkgs, ... }:

{
  home.packages = [ (import ../../packages/node { inherit pkgs; }).chrome-devtools-mcp ];

  xdg.configFile."cd4a/config.json".text = builtins.toJSON {
    usageStatistics = false;
    performanceCrux = false;
  };

  home.sessionVariables = {
    CHROME_DEVTOOLS_MCP_NO_UPDATE_CHECKS = "1";
    CHROME_DEVTOOLS_MCP_NO_USAGE_STATISTICS = "1";
  };
}
