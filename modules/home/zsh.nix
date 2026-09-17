{
  config,
  lib,
  isDarwin,
  dotfilesPath,
  ...
}:

let
  commonAliases = {
    ls = "eza --icons=auto --group-directories-first";
    ll = "eza -la --time-style relative --icons=auto";
    tree = "eza --tree --level=2 --icons=auto";
    cat = "bat";
  };

  commonAbbrevs = [
    {
      name = "ssh work host";
      abbr = "ssh_work";
      snippet = ''ssh -t "$WORK_SSH_USER@$WORK_SSH_HOST" "bash -c \"export TERM=xterm-256color;bash --login;\""'';
    }
    {
      name = "docker login (ECR)";
      abbr = "docker_login";
      snippet = "aws ecr get-login-password | docker login --username AWS --password-stdin \"https://$WORK_ECR_REGISTRY\"";
    }
    {
      name = "sphinx build env";
      abbr = "sphinx_build_env";
      snippet = "docker run -it --rm --platform linux/amd64 --entrypoint /bin/bash -w /work_on_DOCKER -v $(pwd):/work_on_DOCKER \"$WORK_ECR_REGISTRY/$WORK_SPHINX_IMAGE\"";
    }
    {
      name = "docker compose up";
      abbr = "dcu";
      snippet = "docker compose up -d";
    }
    {
      name = "docker compose down";
      abbr = "dcd";
      snippet = "docker compose down";
    }
    {
      name = "docker compose logs";
      abbr = "dcl";
      snippet = "docker compose logs -f";
    }
    {
      name = "docker compose ps";
      abbr = "dcp";
      snippet = "docker compose ps -a";
    }
    {
      name = "docker compose build";
      abbr = "dcb";
      snippet = "docker compose build";
    }
    {
      name = "nh clean";
      abbr = "nixgc";
      snippet = "nh clean all";
    }
  ];
  darwinAbbrevs = [
    {
      name = "home-manager switch";
      abbr = "nixhs";
      snippet = "home-manager switch --flake ${dotfilesPath}#default";
    }
    {
      name = "darwin-rebuild switch";
      abbr = "nixds";
      snippet = "sudo darwin-rebuild switch --flake ${dotfilesPath}#macos";
    }
  ];
  linuxAbbrevs = [
    {
      name = "nixos-rebuild switch";
      abbr = "nixws";
      snippet = "sudo nixos-rebuild switch --flake ${dotfilesPath}#wsl";
    }
  ];
in
{
  programs.zabrze = {
    enable = true;
    settings.abbrevs = commonAbbrevs ++ (if isDarwin then darwinAbbrevs else linuxAbbrevs);
  };

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      save = 10000;
      size = 10000;
    };

    shellAliases = commonAliases;

    envExtra = ''
      [ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        _comp_options+=(globdots)
      '')

      ''
        # Rendered by `just secrets`; may not exist.
        [[ -r "${config.xdg.configHome}/zsh/work.zsh" ]] && source "${config.xdg.configHome}/zsh/work.zsh"

        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

        ghq-fzf() {
          local dir
          dir=$(ghq list --full-path | fzf --reverse --preview "bat --color=always --style=plain --line-range=:500 {}/README.md 2>/dev/null || echo No README")
          [[ -n "$dir" ]] && cd "$dir"
        }

        # Generated files are hidden from git unless --plain is given.
        nix-devshell() {
          emulate -L zsh
          local plain=""
          if [[ "$1" == "--plain" ]]; then
            plain=1
            shift
          fi
          local template="$1"
          local flake="github:yagipass/nix-templates"
          if [[ -z "$template" ]]; then
            print -u2 "Usage: nix-devshell [--plain] <template-name>"
            print -u2 "Available:"
            nix flake show "$flake" >&2
            return 1
          fi
          nix flake init -t "$flake#$template" || return 1
          if [[ -z "$plain" ]] && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            git add --intent-to-add flake.nix flake.lock .envrc &&
              git update-index --skip-worktree flake.nix flake.lock .envrc
            local exclude="$(git rev-parse --path-format=absolute --git-common-dir)/info/exclude"
            local prefix="$(git rev-parse --show-prefix)"
            grep -qxF "/$prefix.direnv/" "$exclude" 2>/dev/null ||
              print -r -- "/$prefix.direnv/" >> "$exclude"
          fi
          direnv allow
        }

        ghq-fzf-widget() {
          zle push-line
          BUFFER="ghq-fzf"
          zle accept-line
        }
        zle -N ghq-fzf-widget
        bindkey "^g" ghq-fzf-widget
      ''
    ];
  };
}
