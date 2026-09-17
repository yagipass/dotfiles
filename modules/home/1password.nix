{
  lib,
  pkgs,
  isDarwin,
  ...
}:

{
  home.packages =
    if isDarwin then
      [ pkgs._1password-cli ]
    else
      [ (pkgs.writeShellScriptBin "op" ''exec op.exe "$@"'') ];
}
// lib.optionalAttrs isDarwin {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "1password-cli" ];
}
