{ pkgs, ... }:

{
  # packages/jdk-mission-control/package.nix pins the same zulu21.
  programs.java = {
    enable = true;
    package = pkgs.zulu21;
  };
}
