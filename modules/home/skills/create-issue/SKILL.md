---
name: create-issue
description: Open a GitHub issue in one of the user's own repositories with gh. Use this whenever the user asks to create, open, or file an issue, "make an issue", or "track this in an issue".
---

# Create Issue

Opening issues in repositories that the user owns is authorized. Editing,
closing, labelling, and commenting on existing issues are not.

## Workflow

1. Resolve the current repository, or the one the user names, with
   `gh repo view [<owner>/<repo>] --json nameWithOwner,owner,hasIssuesEnabled`.
   If its owner is not `gh api user --jq .login`, or issues are disabled,
   stop and ask the user.
2. If the problem is a security vulnerability, do not open an issue. Give the
   user `https://github.com/<owner>/<repo>/security/advisories/new` and stop.
3. Search open and closed issues with a few sets of keywords:
   `gh issue list -R <owner>/<repo> --state all --search '<keywords>'`. If an
   open issue already covers the problem, report its URL and stop. Link a
   closed one that covers it from the new issue.
4. Read the code, configuration, and docs the issue is about, so the body
   matches what the repository does now. If the request does not match the
   repository, for example because it asks for something already in place,
   stop and ask the user.
5. List the templates on the default branch with
   `gh api repos/<owner>/<repo>/contents/.github/ISSUE_TEMPLATE --jq '.[].name'`,
   where a 404 means there are none and `config.yml` is not a template. Read
   the one that fits the issue:

   ```sh
   gh api repos/<owner>/<repo>/contents/.github/ISSUE_TEMPLATE/<file> --jq .content | base64 -d
   ```

6. Write the title and body as described below. If the request covers several
   independent problems, write one issue for each.
7. Open the issue. Pass the template's `labels`, or without a template the
   label for the title prefix: `bug` for `bug:`, `enhancement` for `feat:`,
   and `documentation` for `doc:`. Skip labels that
   `gh label list -R <owner>/<repo>` does not show. Attach images or videos
   the user supplied with `--attach '<file>#<alt text>'`; gh cannot attach
   other files.

   ```sh
   gh issue create -R <owner>/<repo> --title "bug: ..." --label bug --body-file - <<'BODY'
   ...
   BODY
   ```

8. Report the issue URL.

## Title

- Start with the template's `title`. Without a template, start with `bug: `,
  `feat: `, or `doc: `.
- Follow it with an English phrase that a search would find, lowercase except
  for names and identifiers: the component and the symptom for a bug, the
  outcome for a feature, not the fix.
  - Good: `doc: home page has no <h1>, and its title is only "Verbatime"`
  - Bad: `bug: build fails`, `feat: improve CI`

## Body

Write in English, as the user filing their own issue, without referring to
"the user" or "the reporter". Describe the problem or request as someone using
the project sees it: what they did, what happened, and what they want to be
able to do. Leave out fixes, ways to implement the request, guesses at the
cause, and the files or functions behind the problem. Those are for whoever
works on the issue to find. State only what was observed, what was run, or
what the user said. Paste errors and logs verbatim in fenced code blocks,
never as screenshots, and put long ones in `<details>`. Leave out secrets,
tokens, and work-internal values, including any in logs and paths. Link
related issues and pull requests in this repository as `#N`. Do not link to
other repositories or reference anything in them, such as `owner/repo#N`,
`owner/repo@sha`, or their URLs.

With a template, fill it in by hand, since `gh issue create` does not read
issue forms:

- Follow the instructions in its `markdown` elements and field descriptions,
  except where they ask for a fix or an implementation.
- Write one `### <label>` section per field, in the form's order, as the web
  form does. Drop optional fields you have nothing for or that ask only for a
  fix. If a required field cannot be filled from the conversation or the
  repository, or only with a fix, ask the user. Put the value of a field with
  `render:` in a code block of that language.
- If the form has no `Checked so far` field, add a `### Checked so far`
  section right after the reproduction or proposal field.
- Write a field that matches a section in the list below, such as the
  proposal or `Checked so far` field, as that section says.
- For a Markdown template, keep its headings.

Without a template, use Markdown sections in this order, sized to the issue,
and drop the ones that do not apply:

1. `## Problem`: for a bug, what happened and what was expected. Otherwise,
   what the user is trying to do and where the current state falls short.
2. `## How to reproduce`: bugs only. Minimal numbered steps, whether it
   happens every time, and the versions and OS involved.
3. `## Proposal`: the behavior wanted, as someone using the project would see
   it, with example usage. For docs, what the reader needed to find.
4. `## Alternatives`: what the user does now instead, and other tools or
   workflows they tried, with why each falls short.
5. `## Checked so far`: what the user or you actually ran and what it showed,
   ending with a `Not checked yet:` line. Say so here if nobody has
   reproduced the bug.
