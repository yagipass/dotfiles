{ username, ... }:

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
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "zabrze-nix.cachix.org-1:X36vl+otCAj6rchY63NSY16K/xbyiChWm5gVKtaY0Rg="
    ];
    trusted-users = [ username ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

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
