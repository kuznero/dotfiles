---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a conventional commit with auto-generated message
argument-hint: "[git-commit-flags]"
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits (for style reference): !`git log --oneline -10`

## Your Task

Create a conventional commit following the Conventional Commits specification (conventionalcommits.org v1.0.0).

**Arguments:** $ARGUMENTS (optional git commit flags like --no-verify)

### Required Format:

```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

### Specification Rules:

- Commits MUST be prefixed with a type: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Type 'feat' MUST be used when adding a new feature
- Type 'fix' MUST be used when representing a bug fix
- A scope MAY be provided after type in parenthesis, e.g., 'fix(parser):'
- Description MUST immediately follow the colon and space
- Description is a short summary of code changes
- A longer body MAY be provided after the description (one blank line after)
- Body is free-form and MAY consist of multiple newline-separated paragraphs
- Footers MAY be provided one blank line after the body
- Each footer MUST consist of: word token + (': ' or ' #') + string value
- Footer tokens MUST use '-' instead of spaces, e.g., 'Acked-by:' (except BREAKING CHANGE)
- Breaking changes MUST be indicated by '!' before ':' OR 'BREAKING CHANGE:' footer
- If '!' is used, 'BREAKING CHANGE:' footer MAY be omitted
- BREAKING CHANGE MUST be uppercase when used as footer token

### Instructions:

1. Analyze the staged and unstaged changes
2. Stage all relevant changes (use git add)
3. Generate an appropriate conventional commit message
4. Create the commit with the generated message
5. If arguments are provided, pass them to git commit (e.g., --no-verify)
6. Use a single message to stage changes and create the commit

Do not use any other tools or send any other text besides these tool calls.
