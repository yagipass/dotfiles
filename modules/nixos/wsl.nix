{
  pkgs,
  username,
  dotfilesPath,
  homeSpecialArgs,
  ...
}:

{
  wsl = {
    enable = true;
    defaultUser = username;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://cache.numtide.com"
        "https://zabrze-nix.cachix.org"
      ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "zabrze-nix.cachix.org-1:X36vl+otCAj6rchY63NSY16K/xbyiChWm5gVKtaY0Rg="
      ];
      trusted-users = [ username ];
    };

    optimise.automatic = true;
  };

  i18n.defaultLocale = "ja_JP.UTF-8";
  time.timeZone = "Asia/Tokyo";

  programs = {
    nix-ld.enable = true;

    nh = {
      enable = true;
      flake = dotfilesPath;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 30d";
      };
    };

    zsh.enable = true;
  };
  users.users.${username}.shell = pkgs.zsh;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = homeSpecialArgs;
    users.${username} = {
      imports = [ ../home ];
    };
  };

  system.stateVersion = "26.05";
}
