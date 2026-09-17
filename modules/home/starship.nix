_:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      character.success_symbol = "[\\$](bold green)";
      character.error_symbol = "[\\$](bold red)";
      aws.disabled = true;
      git_status.disabled = true;
    };
  };
}
