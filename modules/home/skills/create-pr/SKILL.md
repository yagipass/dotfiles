---
name: create-pr
description: Commit the current change, push it, and open a pull request. Use this whenever the user asks to create or open a PR, "open a PR", or "push this and make a PR".
---

# Create PR

Creating a branch, committing, pushing, and opening a pull request are
authorized. Merging, force-pushing, and amending are not.

## Workflow

1. Run `git status --short` and `git branch --show-current`, and get the
   default branch with
   `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`.
2. Commit uncommitted changes with the `commit` skill, passing `branch: true`
   on the default branch. Never push to the default branch. If the commits
   are already on it, ask the user.
3. Run the checks the repository's AGENTS.md requires, unless they already ran
   on this diff.
4. Write the title and body in English. The repository's pull request
   template and contributing guide, including any rules on AI-written text,
   take precedence over this step.
   - Title: the commit subject, or one Conventional Commits subject covering
     all commits.
   - Body: no headings, sized to the change. Keep this order and drop the
     parts that do not apply:
     1. The problem and who it affects.
     2. What changed.
     3. Rejected alternatives and known shortcomings.
     4. `Checked:` and `Not checked:` lists, focused on what you verified by
        hand. Checks that CI also runs need one line at most.
     5. Breaking changes and manual steps needed after merging.
     6. `Closes #N`, only for issues named in the conversation.
   - The body may become the squash commit message. Keep only what stays true
     after merging, and put anything else in a comment.
5. Push and open the pull request. For a visual change, attach each real
   screenshot or recording with `--attach '<file>#<alt text>'`.

   ```sh
   git push -u origin HEAD
   gh pr create --title "feat(scope): add something useful" --body-file - <<'BODY'
   ...
   BODY
   ```

   If the branch already has an open pull request, push and skip
   `gh pr create`.

6. Report the pull request URL. Do not wait for CI.
