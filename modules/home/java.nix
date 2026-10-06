{ pkgs, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.zulu21;
  };

  programs.gradle = {
    enable = true;
    package = pkgs.gradle_9;
  };
}
