{
  config,
  pkgs,
  isDarwin,
  ...
}:

{
  home.packages = with pkgs; [
    ghq
  ];

  programs = {
    git = {
      enable = true;

      lfs.enable = true;

      ignores = [
        "**/.claude/settings.local.json"
        ".postgres/"
        ".DS_Store"
      ];

      attributes = [
        ".envrc      text eol=lf"
        ".zshrc      text eol=lf"
        ".zshenv     text eol=lf"
        ".zprofile   text eol=lf"
        "*.sh        text eol=lf"
        "gradlew     text eol=lf"
        "*.nix       text eol=lf"
        "flake.lock  text eol=lf"
      ];

      includes = [
        {
          path = "~/.config/git/profiles.inc";
        }
      ];

      signing = {
        format = "ssh";
        signer =
          if isDarwin then
            "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
          else
            "${pkgs.writeShellScript "op-ssh-sign" ''exec op-ssh-sign-wsl.exe "$@"''}";
      };

      settings = {
        ghq.root = "~/ghq";
        core.autocrlf = "false";
        merge.conflictStyle = "zdiff3";
        gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = false;
      options = {
        navigate = true;
        dark = true;
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = false;
      settings = {
        git_protocol = "https";
        aliases.co = "pr checkout";
      };
      extensions = [
        pkgs.gh-poi
      ];
    };

    gh-dash = {
      enable = true;
      settings = {
        pager = {
          diff = "delta";
        };
      };
    };

    lazygit = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        gui = {
          language = "ja";
          showIcons = true;
        };
        git.diffRenderers = [
          {
            colorArg = "always";
            command = "delta --dark --paging=never";
          }
        ];
      };
    };

    zsh.initContent = ''
      lg() {
        export LAZYGIT_NEW_DIR_FILE="${config.xdg.cacheHome}/lazygit/newdir"
        command lazygit "$@"
        if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
          cd "$(cat "$LAZYGIT_NEW_DIR_FILE")"
          rm -f "$LAZYGIT_NEW_DIR_FILE" > /dev/null
        fi
      }
    '';
  };
}
