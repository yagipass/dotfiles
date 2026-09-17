_:

{
  programs.ghostty = {
    enable = true;
    package = null; # installed as a Homebrew cask

    settings = {
      background-opacity = "0.8";
      background-blur-radius = 20;
      macos-titlebar-style = "transparent";
      macos-window-shadow = true;
      copy-on-select = true;
      clipboard-read = "allow";
      clipboard-write = "allow";

      keybind = [
        # \x02 is the herdr prefix key (C-b).
        "cmd+enter=text:\\x02-"
        "cmd+shift+enter=text:\\x02v"
        "cmd+left=text:\\x02h"
        "cmd+down=text:\\x02j"
        "cmd+up=text:\\x02k"
        "cmd+right=text:\\x02l"
        "cmd+shift+left=text:\\x02p"
        "cmd+shift+right=text:\\x02n"
        "cmd+w=text:\\x02w"
      ];
    };
  };
}
