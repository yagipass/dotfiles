{ pkgs, ... }:

{
  home.packages = [ (import ../../packages/node { inherit pkgs; }).chrome-devtools-mcp ];
}
