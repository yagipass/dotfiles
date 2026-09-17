{ config, dotfilesPath, ... }:

{
  home.file = {
    ".claude/CLAUDE.md".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/home/claude/CLAUDE.md";
    ".claude/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/home/claude/settings.json";
    ".claude/statusline.ts".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/home/claude/statusline.ts";
    ".claude/skills/commit".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/modules/home/skills/commit";
  };
}
