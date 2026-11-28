{ config, lib, ... }:

{
  home.activation.karabinerConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run install -D -m 644 $VERBOSE_ARG ${./karabiner.json} ${lib.escapeShellArg "${config.xdg.configHome}/karabiner/karabiner.json"}
  '';
}
