{
  lib,
  agentSkillsModule,
  isDarwin,
  ...
}:

{
  imports = [ agentSkillsModule ];

  programs.agent-skills = {
    enable = true;

    sources = {
      mattpocock = {
        input = "mattpocock-skills";
        subdir = "skills";
      };
      chrome-devtools-mcp = {
        input = "chrome-devtools-mcp-skills";
        subdir = "skills";
      };
    };

    skills.explicit = {
      grilling = {
        from = "mattpocock";
        path = "productivity/grilling";
      };
    }
    // lib.optionalAttrs isDarwin {
      chrome-devtools-cli = {
        from = "chrome-devtools-mcp";
        path = "chrome-devtools-cli";
      };
    };

    targets = {
      claude = {
        enable = true;
        structure = "link";
        dest = ".claude/skills";
      };
      codex = {
        enable = true;
        structure = "link";
        dest = ".codex/skills";
      };
    };
  };
}
