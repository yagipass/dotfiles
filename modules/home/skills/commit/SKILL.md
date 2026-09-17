---
name: commit
description: Create a git commit with an English Conventional Commits message. Use this whenever the user asks to commit, "commit this", or "make a commit".
argument-hint: "[branch: true|false]"
---

# Commit

Write an English Conventional Commits message that matches the repository's
history, then commit. Committing is authorized. Pushing, amending, and opening
a pull request are not.

## Arguments

One optional argument, `branch`, as `true` or `false`. Anything else means
`false`.

- `true`: create a branch from the current HEAD with `git switch -c` and
  commit on it. Name it `<type>/<short-kebab-subject>` from the commit
  message, following the prefix style in `git branch -a`, for example
  `feat/add-eclipse-rcp`.
- `false`: commit on the current branch.

## Workflow

1. Run `git status --short` and `git diff --cached --stat`. If nothing is
   staged, stage the files that belong to this change. Leave out unrelated,
   generated, or sensitive files such as `.env` and credentials, and say what
   you left out.
2. Binary files go through git-lfs. Before staging one, confirm that
   `git check-attr filter <file>` prints `lfs`. Otherwise run
   `git lfs track '<pattern>'` and stage `.gitattributes` too.
3. Run `git log --oneline -30` and reuse the types and scopes already in use.
4. Write the message. If the staged diff mixes unrelated changes, propose
   splitting it into several commits.
5. If `branch` is `true`, create the branch now.
6. Commit with a heredoc so the body survives shell quoting:

   ```sh
   git commit -m "$(cat <<'MSG'
   feat(scope): add something useful

   Why the change was needed and what it does at a high level.
   MSG
   )"
   ```

7. Run `git log -1 --stat` and report the branch, subject, and body. If a
   pre-commit hook fails, report the cause and stop. Do not retry, fix, or
   bypass it.

## Message format

```
<type>(<scope>): <subject>

<body>

<footer>
```

- Type: `feat` for new behaviour or config, `fix` for corrected behaviour
  including a wrongly set value, `refactor` for restructuring without behaviour
  change, `docs`, `chore`, `test`, `perf`, `build`, `ci`, `style`, `revert`.
  Dependency updates are `chore(deps)` unless the repo uses `build`.
- Scope: optional, lowercase, the affected module, package, or tool.
- Subject: at most 72 characters.
- Body: required. Explain why the change was needed and what changed at a high
  level, wrapped at 72 columns. Do not restate the subject or list files.
- Footer: `BREAKING CHANGE:` with `!` after the type or scope when applicable.
  Do not invent issue or PR references. Add trailers only when the user or the
  tool requires them.
- Everything in English, whatever language the conversation uses.
