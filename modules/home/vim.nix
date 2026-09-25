{ config, ... }:

{
  xdg.configFile."vim/vimrc".text = ''
    unlet! skip_defaults_vim
    source $VIMRUNTIME/defaults.vim
    set viminfofile=${config.xdg.stateHome}/vim/viminfo
    silent! call mkdir(fnamemodify(&viminfofile, ':h'), 'p')
  '';
}
