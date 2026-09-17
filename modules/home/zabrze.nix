{
  config,
  lib,
  pkgs,
  zabrze,
  ...
}:

let
  cfg = config.programs.zabrze;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.programs.zabrze = {
    enable = lib.mkEnableOption "zabrze, a zsh abbreviation expansion plugin";

    package = lib.mkOption {
      type = lib.types.package;
      default = zabrze;
      defaultText = lib.literalExpression "zabrze # zabrze-nix flake input";
      description = "The zabrze package to use.";
    };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = "Settings written to ~/.config/zabrze/config.toml.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."zabrze/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = settingsFormat.generate "zabrze-config.toml" cfg.settings;
    };

    programs.zsh.initContent = ''
      eval "$(${lib.getExe cfg.package} init --bind-keys)"
    ''
    + lib.optionalString config.programs.zsh.autosuggestion.enable ''
      # Offer zabrze triggers as zsh-autosuggestions candidates.
      typeset -ga __zabrze_triggers
      __zabrze_triggers=( ''${''${(f)"$(${lib.getExe cfg.package} list)"}%%=*} )
      _zsh_autosuggest_strategy_zabrze_triggers() {
        emulate -L zsh
        setopt EXTENDED_GLOB
        local prefix="''${1//(#m)[\\*?[\]<>()|^~#]/\\$MATCH}"
        typeset -g suggestion="''${__zabrze_triggers[(r)$prefix*]}"
      }
      ZSH_AUTOSUGGEST_STRATEGY=(zabrze_triggers $ZSH_AUTOSUGGEST_STRATEGY)
    '';
  };
}
