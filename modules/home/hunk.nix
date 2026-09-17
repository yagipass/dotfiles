{ llmAgents, ... }:

{
  home.packages = [ llmAgents.hunk ];
  programs.git.settings.core.pager = "hunk pager";
  home.file.".claude/skills/hunk-review".source = "${llmAgents.hunk}/skills/hunk-review";
}
