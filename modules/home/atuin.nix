_:

{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    flags = [ "--disable-up-arrow" ];

    settings = {
      store_failed = false;
      search_mode = "fuzzy";
      enter_accept = false;
      secrets_filter = true;
    };
  };
}
