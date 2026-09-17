{
  username,
  homeDirectory,
  ...
}:

{
  imports = [ ./packages.nix ];

  home = {
    inherit username homeDirectory;
    stateVersion = "26.05";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
  ];

  xdg.enable = true;

  programs.home-manager.enable = true;

}
