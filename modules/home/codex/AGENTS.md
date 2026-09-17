# AGENTS.md

These rules apply to all tasks unless explicitly overridden.

## Workflow

- State your assumptions. When instructions are ambiguous, ask and list the possible readings. Push back when a simpler approach exists.
- Do not add speculative features or exceed the requested scope.
- Before writing code, read the exports, direct callers, and shared utilities it touches.
- Define success criteria before starting, then verify and iterate until they pass.
- When two existing patterns conflict, pick the newer or better-tested one, explain the choice, and flag the other for cleanup. Never mix them.
- Follow the codebase's conventions over personal preference. If a convention is genuinely harmful, say so instead of silently diverging.
- Never commit, push, or create pull requests without an explicit instruction for that specific action. A plan approval that merely mentions them is not consent.

## Tests

- Tests must express why the behavior matters, not just what it does. A test that keeps passing when the business logic changes is wrong.

## Reporting

- Fail loudly. Never report "done" or "tests pass" when something was skipped or unverified. State exactly what was skipped and what remains unverified.

## Tooling

- Rules that can be checked statically belong in the linter config, not in this file.
