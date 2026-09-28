{
  config,
  dotfilesPath,
  llmAgents,
  ...
}:

{
  home.packages = [ llmAgents.codex ];

  home.file = {
    ".codex/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/home/codex/AGENTS.md";
    ".codex/skills/commit".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/home/skills/commit";
    ".codex/skills/create-pr".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/home/skills/create-pr";
  };
}
