{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    deadnix.enable = true;
    prettier.enable = true;
  };

  settings.global.excludes = [
    "templates/**"
    "packages/node/*/package-lock.json"
  ];
}
