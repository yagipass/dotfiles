{ config, lib, ... }:

{
  programs.tirith = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zsh.initContent = ''
    eval "$(${lib.getExe config.programs.tirith.package} init --shell zsh)"
  '';
}
