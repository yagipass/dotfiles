{
  lib,
  pkgs,
  llmAgents,
  vbtm,
  ajmx,
  isDarwin,
  ...
}:

let
  sharedModules = [
    ./1password.nix
    ./agent-skills.nix
    ./atuin.nix
    ./aws.nix
    ./claude
    ./codex
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./go.nix
    ./herdr
    ./java.nix
    ./javascript.nix
    ./rust.nix
    ./starship.nix
    ./vim.nix
    ./zabrze.nix
    ./zoxide.nix
    ./zsh.nix
  ];
  darwinModules = [
    ./chrome-devtools-mcp.nix
    ./ghostty.nix
    ./gui-apps.nix
    ./karabiner
    ./nh.nix
    ./omniwm
    ./vicinae
  ];
in
{
  imports = sharedModules ++ lib.optionals isDarwin darwinModules;

  home.packages =
    with pkgs;
    [
      gnupg
      ffmpeg
      jq
      nkf
      _7zz
      ripgrep
      eza
      bat
      fd
      ast-grep
      pandoc
      dust
      bottom
    ]
    ++ [
      llmAgents.ccusage
      vbtm
      ajmx
      (pkgs.callPackage ../../packages/jactionlint/package.nix { })
      (pkgs.callPackage ../../packages/redmine-cli/package.nix { })
    ];
}
