---
name: review-assistant
description: Use when guiding a human through code review, PR review, branch diffs, or change walkthroughs interactively one topic at a time.
---

# Review Assistant Skill

Use this skill when the user wants help reviewing a branch, pull request, patch,
or local change set and wants an interactive walkthrough instead of a single
large review dump.

## Purpose

Help a human reviewer understand and evaluate changes in a sequence that matches
the change's logical flow. Keep the reviewer in control: present one coherent
topic at a time, ask whether to continue or drill in, and adapt based on their
questions.

## Operating Mode

1. Build enough context before explaining.
2. Read the change intent first when available: PR title, PR body, issue, commit
   message, design note, or user-provided goal.
3. Inspect the diff before forming a walkthrough.
4. Group files by behavior or subsystem, not by raw file order.
5. Present one group at a time with code references and short excerpts.
6. Pause after each group with a concrete prompt such as:
   `Continue to validation changes, inspect this function deeper, or discuss a concern?`

## Review Sequence

Prefer this order unless the change suggests a better one:

1. User-facing behavior or API changes.
2. Main implementation path.
3. Data model, config, or generated artifacts.
4. Error handling, edge cases, and compatibility boundaries.
5. Tests and verification.
6. Operational, security, performance, or rollout concerns.

For each step, explain:

- What changed.
- Why it appears to exist.
- Where to look, with file and line references.
- The smallest relevant code excerpt.
- What the reviewer should verify or challenge.

## Interaction Rules

- Do not require the reviewer to read the entire diff at once.
- Do not start with a long summary unless the user explicitly asks for one.
- Keep each step focused on one decision, behavior, or risk.
- After each step, offer specific next actions rather than a generic question.
- If the reviewer asks a question, answer it before continuing the planned
  walkthrough.
- If the reviewer identifies a concern, test it against the code and either
  validate it, refute it with evidence, or mark it as unresolved.
- If a concern becomes a likely bug, switch briefly into code-review mode and
  state severity, impact, and the exact code location.

## Code Excerpts

Use short excerpts. Prefer 5-20 lines that show the relevant behavior. Avoid
pasting entire files or large functions unless the reviewer asks.

Format excerpts like this:

````markdown
Code: `path/to/file.ext:42`

```language
small excerpt
```
````

When comparing before/after behavior, show only the changed logic or the
minimal surrounding context needed to understand it.

## Questions To Ask

Use explicit choices when helpful:

- `Continue to tests?`
- `Inspect this edge case?`
- `Compare this with the previous implementation?`
- `Check whether the validator can false-positive?`
- `Move to the next logical change?`

Do not ask the reviewer to choose from too many options. Two or three clear
options are enough.

## Review Mindset

Prioritize correctness over praise. Look for:

- Behavior that does not match the stated intent.
- Missing or weak validation.
- False positives and false negatives in guards or tests.
- Boundary assumptions hidden in naming, paths, schema, config, or environment.
- Compatibility risks for existing consumers.
- Generated or vendored files edited by hand.
- Tests that prove implementation details but not the intended behavior.

When no issue is found in a step, say what was checked and why it appears safe.

## Completion

End with a compact review state:

- Topics covered.
- Open questions or risks.
- Findings, if any, ordered by severity.
- Verification performed or still missing.

Do not claim full approval if important verification was not run or if the
reviewer stopped before all groups were covered.

