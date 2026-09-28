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
   when on the default branch. Skip this when everything is already committed
   on a feature branch. Never push to the default branch. If the commits are
   already on it, ask the user.
3. Run the checks the repository's AGENTS.md requires, unless they already ran
   on this diff.
4. Write the title and body in English.
   - Title: the commit subject, or for several commits one Conventional
     Commits subject that covers them.
   - Body: no headings, sized to the change. Keep this order and drop the
     parts that do not apply:
     1. Why the change was needed.
     2. What changed, as prose or a short list.
     3. `Checked:` and `Not checked:` lists. Say what was only evaluated and
        not built or run.
     4. Manual steps the change needs after merging.
     5. `Closes #N`, only for issues named in the conversation.
5. Push and open the pull request. For a visual change, add
   `--attach '<file>#<alt text>'` for each real screenshot or recording you
   have. Do not create media just for the pull request.

   ```sh
   git push -u origin HEAD
   gh pr create --title "feat(scope): add something useful" --body-file - <<'BODY'
   ...
   BODY
   ```

   If the branch already has an open pull request, push and skip
   `gh pr create`.

6. Report the pull request URL. Do not wait for CI.
