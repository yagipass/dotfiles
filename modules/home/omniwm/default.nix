{
  omniwmModule,
  omniwmLib,
  ...
}:

{
  imports = [ omniwmModule ];

  programs.omniwm = {
    enable = true;
    launchd.keepAlive = true;

    settings = {
      focus.followsWindowToMonitor = true;
      general.updateChecksEnabled = false;
      quakeTerminal.enabled = false;
      workspaceBar.reserveLayoutSpace = true;

      appRules = [
        (omniwmLib.appRule "com.openai.codex" {
          minHeight = 600.0;
          minWidth = 800.0;
        })
        (omniwmLib.appRule "com.eltima.cmd1.pro.mas" {
          minHeight = 550.0;
          minWidth = 950.0;
        })
        (omniwmLib.appRule "com.google.Chrome" {
          minHeight = 375.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "dev.zed.Zed" {
          minHeight = 240.0;
          minWidth = 360.0;
        })
        (omniwmLib.appRule "com.apple.Safari" {
          minHeight = 220.0;
          minWidth = 574.0;
        })
        (omniwmLib.appRule "app.zen-browser.zen" {
          minHeight = 495.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "org.mozilla.firefox" {
          minHeight = 120.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "company.thebrowser.dia" {
          minHeight = 420.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "com.spotify.client" {
          minHeight = 600.0;
          minWidth = 800.0;
        })
        (omniwmLib.appRule "com.hnc.Discord" {
          minHeight = 500.0;
          minWidth = 800.0;
        })
        (omniwmLib.appRule "com.mitchellh.ghostty" {
          minHeight = 48.0;
          minWidth = 90.0;
        })
        (omniwmLib.appRule "com.microsoft.Outlook" {
          minHeight = 650.0;
          minWidth = 930.0;
        })
        (omniwmLib.appRule "com.apple.MobileSMS" {
          minHeight = 320.0;
          minWidth = 660.0;
        })
        (omniwmLib.appRule "com.apple.finder" { layout = "float"; })
      ];

      hotkeys = omniwmLib.hotkeys {
        "assignFocusedWindowToScratchpad.1" = "Option+Shift+S";
        "toggleQuakeTerminal" = "Unassigned";
        "toggleScratchpad.1" = "Option+S";
      };
    };
  };
}
