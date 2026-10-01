case "$PWD/" in
  "$HOME/ghq/{{ op://dotfiles/work/git/domain }}/"*)
    MAVEN_ARGS="--settings $HOME/.m2/work-settings.xml${MAVEN_ARGS:+ $MAVEN_ARGS}"
    ;;
esac
