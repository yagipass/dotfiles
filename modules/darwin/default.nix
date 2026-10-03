{ lib, username, ... }:

{
  imports = [ ./homebrew.nix ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://cache.numtide.com"
      "https://zabrze-nix.cachix.org"
      "https://verbatime.cachix.org"
      "https://ajmx.cachix.org"
      "https://yagipass.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "zabrze-nix.cachix.org-1:X36vl+otCAj6rchY63NSY16K/xbyiChWm5gVKtaY0Rg="
      "verbatime.cachix.org-1:Qqie2fyx4q6SYyjWuwmkr78fNAizxW1acBKeiAcHql8="
      "ajmx.cachix.org-1:GIHBWC7DAYdQHwsuTKF6ouPF0ziSXtxRcktMOr4xXMk="
      "yagipass.cachix.org-1:IDx7B73P4TC7rE854lIYEwy/gd73PV3KE51tIV0vXOc="
    ];
    trusted-users = [ username ];
    use-xdg-base-directories = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  environment.profiles = lib.mkOrder 800 [ "$HOME/.local/state/nix/profile" ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system.defaults = {
    NSGlobalDomain = {
      NSAutomaticCapitalizationEnabled = false;
      AppleInterfaceStyle = "Dark";
    };
    dock = {
      autohide = true;
      orientation = "left";
      show-process-indicators = true;
      show-recents = false;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf"; # search the current folder
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # list view
    };

    # No dedicated nix-darwin option exists for this.
    CustomUserPreferences."com.apple.dock" = {
      enterMissionControlByTopWindowDrag = false;
    };
  };

  system = {
    primaryUser = username;
    stateVersion = 6;
  };
}
