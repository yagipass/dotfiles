{
  lib,
  username,
  homeDirectory,
  isDarwin,
  ...
}:

{
  imports = [ ./packages.nix ];

  home = {
    inherit username homeDirectory;
    stateVersion = "26.05";
  };

  home.sessionPath = lib.mkBefore [
    "$HOME/.local/bin"
  ];

  xdg.enable = true;

  nix.assumeXdg = isDarwin;

  programs.home-manager.enable = true;

}
