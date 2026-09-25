{ config, ... }:

let
  cargoHome = "${config.xdg.dataHome}/cargo";
in
{
  home.sessionVariables.CARGO_HOME = cargoHome;
  home.sessionPath = [ "${cargoHome}/bin" ];
}
