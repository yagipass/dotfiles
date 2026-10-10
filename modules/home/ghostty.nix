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
        "cmd+digit_1=text:\\x02\\x1b1"
        "cmd+digit_2=text:\\x02\\x1b2"
        "cmd+digit_3=text:\\x02\\x1b3"
        "cmd+digit_4=text:\\x02\\x1b4"
        "cmd+digit_5=text:\\x02\\x1b5"
        "cmd+digit_6=text:\\x02\\x1b6"
        "cmd+digit_7=text:\\x02\\x1b7"
        "cmd+digit_8=text:\\x02\\x1b8"
        "cmd+digit_9=text:\\x02\\x1b9"
      ];
    };
  };
}
