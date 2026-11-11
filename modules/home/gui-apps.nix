{ pkgs, nestodo-desktop, ... }:

{
  home.packages = with pkgs; [
    cyberduck
    keycastr
    drawio
    dbeaver-bin
    (callPackage ../../packages/jdk-mission-control/package.nix { })
    nestodo-desktop
  ];

  targets.darwin.copyApps = {
    enable = true;
    directory = "Applications/Home Manager Apps";
  };
}
