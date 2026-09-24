{
  lib,
  pkgs,
  llmAgents,
  vbtm,
  isDarwin,
  ...
}:

let
  nodePackages = import ../../packages/node { inherit pkgs; };
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
    ./herdr
    ./hunk.nix
    ./java.nix
    ./javascript.nix
    ./starship.nix
    ./tirith.nix
    ./zabrze.nix
    ./zoxide.nix
    ./zsh.nix
  ];
  darwinModules = [
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
      p7zip
      ripgrep
      eza
      bat
      fd
      ast-grep
      termshot
      pandoc
      dust
      bottom
    ]
    ++ [
      llmAgents.ccusage
      vbtm
    ]
    ++ lib.optionals isDarwin [
      nodePackages.chrome-devtools-mcp
    ];
}
