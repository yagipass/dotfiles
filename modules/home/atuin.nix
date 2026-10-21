{
  config,
  pkgs,
  isDarwin,
  ...
}:

{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    package =
      if isDarwin then
        pkgs.atuin.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace crates/atuin/tests/common/mod.rs \
              --replace-fail '("TERM".into(), "xterm-256color".into()),' \
                '("TERM".into(), "xterm-256color".into()), ("NOSYSBASHRC".into(), "1".into()),'
          '';
        })
      else
        pkgs.atuin;

    flags = [ "--disable-up-arrow" ];

    settings = {
      store_failed = false;
      search_mode = "fuzzy";
      enter_accept = false;
      secrets_filter = true;
      logs.dir = "${config.xdg.stateHome}/atuin/logs";
      ai.enabled = false;
    };
  };
}
