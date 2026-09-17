{ dotfilesPath, ... }:

{
  programs.nh = {
    enable = true;
    flake = dotfilesPath;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 30d";
    };
  };
}
