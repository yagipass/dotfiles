---
name: create-pr
description: Commit the current change, push it, and open a pull request, or a stack of them when the change has dependent parts. Use this whenever the user asks to create or open a PR, "open a PR", or "push this and make a PR".
---

# Create PR

Creating branches, committing, pushing, and opening pull requests are
authorized, as are the `--force-with-lease` pushes `gh stack` makes. Merging,
amending, and other force-pushes are not.

## Workflow

1. Run `git status --short`, `git branch --show-current`,
   `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`, and
   `gh stack view --json` (exit 0: on a stack, exit 2: not). Use the
   `gh-stack` skill for `gh stack` commands.
2. Commit uncommitted changes with the `commit` skill. Never push to the
   default branch. If the commits are already on it, ask the user.
   - On a stack, commit each change on the layer that owns it.
   - If the changes hold dependent concerns that are each reviewable alone
     and `gh api 'repos/{owner}/{repo}/stacks' --silent` succeeds, propose
     the layers bottom to top with their files and commit subjects. If the
     user accepts, run `gh stack init` with the first layer's name on the
     default branch, or with the current branch elsewhere, then `gh stack add`
     for each later layer. Name branches as the `commit` skill does, and
     commit only each layer's files on it.
   - Otherwise, pass `branch: true` on the default branch.
3. Run the checks the repository's AGENTS.md requires, unless they already ran
   on this diff. On a stack, run them on each new or changed layer.
4. Write each new pull request's title and body in English, covering only its
   layer on a stack. The repository's pull request template and contributing
   guide, including rules on AI-written text, take precedence.
   - Title: the commit subject, or one Conventional Commits subject covering
     all commits.
   - Body: these Markdown sections in order, sized to the change. Drop those
     that do not apply.
     1. `## Why`: the problem and who it affects.
     2. `## What`: what changed.
     3. `## Trade-offs`: rejected alternatives and known shortcomings.
     4. `## Verification`: `Checked:` and `Not checked:` lists of what you
        verified by hand. Checks CI also runs get one line at most.
     5. `## After merging`: breaking changes and manual steps.
     6. A last line `Closes #N`, only for issues named in the conversation.
   - The body may become the squash commit message. Keep only what stays true
     after merging, and put the rest in a comment.
5. Push and open the pull request. Attach real screenshots or recordings of a
   visual change with `--attach '<file>#<alt text>'`. If the branch already
   has an open pull request, only push.

   ```sh
   git push -u origin HEAD
   gh pr create --title "feat(scope): add something useful" --body-file - <<'BODY'
   ...
   BODY
   ```

   On a stack, submit every layer, then set the title and body of each pull
   request `submit` created. Their numbers are in `branches[].pr.number` of
   `gh stack view --json`.

   ```sh
   gh stack submit --auto --open --remote origin
   gh pr edit 123 --title "feat(scope): add something useful" --body-file - <<'BODY'
   ...
   BODY
   ```

   If a repository rule rejects a push, stop and report it.

6. Report every pull request URL. Do not wait for CI.
