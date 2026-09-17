{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      extraFlags = [ "--force-cleanup" ];
    };

    brews = [
    ];

    casks = [
      "1password"
      "adobe-acrobat-reader"
      "beyond-compare"
      "claude"
      "codex-app"
      "copilot-cli"
      "docker-desktop"
      "eclipse-rcp"
      "ghostty"
      "google-chrome"
      "intune-company-portal"
      "karabiner-elements"
      "microsoft-office-businesspro"
      "obsidian"
      "stats"
      "tailscale-app"
      "visual-studio-code"
      "zoom"
    ];
  };
}
