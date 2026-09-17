{
  config,
  llmAgents,
  dotfilesPath,
  ...
}:

{
  home.packages = [ llmAgents.herdr ];

  # herdr rewrites config.toml itself, so link the repo copy out of store.
  xdg.configFile."herdr/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/home/herdr/config.toml";
    force = true;
  };
}
