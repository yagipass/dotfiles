{ pkgs, ... }:

let
  version = "0.6.8";
  omniwm = pkgs.omniwm.overrideAttrs (_: {
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/BarutSRB/OmniWM/releases/download/v${version}/OmniWM-v${version}.zip";
      hash = "sha256-CCOWPIpcO96FT3/dA82MJcRCGkC9b3SETyyPfBaiZ2U=";
    };
  });
in
{
  programs.omniwm = {
    enable = true;
    package = omniwm;
    settings = ./settings.toml;
  };
}
