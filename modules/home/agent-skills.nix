{
  lib,
  pkgs,
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
      verbatime = {
        input = "verbatime";
        subdir = "skills";
      };
      gh-stack = {
        path = pkgs.gh-stack.src;
        subdir = "skills";
      };
    };

    skills.explicit = {
      grilling = {
        from = "mattpocock";
        path = "productivity/grilling";
      };
      vbtm = {
        from = "verbatime";
        path = "vbtm";
      };
      gh-stack = {
        from = "gh-stack";
        path = "gh-stack";
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
