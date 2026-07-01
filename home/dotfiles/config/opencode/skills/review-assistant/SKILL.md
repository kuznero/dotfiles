---
name: review-assistant
description: Use when helping a human understand and accept or reject a change set: first perform an in-depth independent review, then guide the human interactively one logical topic at a time.
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

## Review Target

Before Stage 1, determine what is being reviewed:

- PR or branch diff when available.
- Base branch or commit range.
- Local staged, unstaged, or full working tree changes.
- Patch file or pasted diff.
- Whether generated, vendored, lockfile, or formatting-only files should be
  included.

If the target is ambiguous, ask one short clarification before reviewing.

## Two-Stage Workflow

### Stage 1: Independent Assistant Review

Before guiding the human, review the change set in depth yourself.

1. Read the stated intent when available: PR title, PR body, issue, commit
   message, design note, or user-provided goal.
2. Read PR discussion when available: review comments, unresolved threads,
   author responses, CI/check comments, and linked issue discussion that explains
   intent or known risks.
3. Read CI/check status when available. Failed checks, skipped tests, flaky jobs,
   and required-but-missing checks should influence the review walkthrough.
4. Treat comments and check output as signals, not truth. Verify important
   claims against the current diff because discussion may be stale, resolved, or
   based on an older revision.
5. Inspect the full diff before presenting conclusions.
6. Identify logical change groups by behavior or subsystem, not by raw file
   order.
7. For large diffs, identify generated, vendored, formatting-only, lockfile, and
   mechanical rename changes early. Review them differently from behavioral code,
   and do not spend human walkthrough time on them unless they carry risk.
8. Look for correctness, compatibility, security, performance, operational,
   and test coverage risks.
9. Note likely findings, unclear areas, and verification gaps.
10. For non-trivial change sets, use focused sub-agents when available to keep
   the top-level context reserved for synthesis and human guidance. Prefer
   narrow assignments such as intent/diff mapping, correctness risks, tests and
   verification, or security/operational concerns.
11. Ask sub-agents for concise, evidence-backed output: logical area, risk or
   finding, file references, confidence, and verification gaps.
12. Treat sub-agent output as input, not as the final review. Reconcile
   conflicts, verify important claims against the code, and carry only useful
   findings into the guided walkthrough.

Do not dump this full internal review as a report unless the user explicitly
asks. Use it to guide the human through the review with confidence and context.

### Stage 2: Guided Human Review

After the independent review, help the human reviewer understand and evaluate
the change one logical topic at a time.

1. Start with a compact map of logical topics, not detailed findings. Recommend
   the first topic and explain why it is the best place to start.
2. Present one coherent group at a time with code references and short excerpts.
3. Explain what changed, why it appears to exist, and what should be verified.
4. Pause after each group and let the human ask questions, challenge reasoning,
   or choose the next area.
5. Maintain lightweight review state: covered topics, skipped topics, deferred
   questions, unresolved risks, and remaining topics.
6. Continue only after answering the human's current questions.

The goal is not for the assistant to approve the change on behalf of the human.
The goal is to make the human reviewer ready to accept, reject, request changes,
or continue investigating.

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
- Do not present the independent review as a full report by default; reveal it
  progressively through the guided walkthrough.
- Do not start with a long summary unless the user explicitly asks for one.
- Keep each step focused on one decision, behavior, or risk.
- After each step, offer specific next actions rather than a generic question.
- If the reviewer asks a question, answer it before continuing the planned
  walkthrough.
- If the reviewer identifies a concern, test it against the code and either
  validate it, refute it with evidence, or mark it as unresolved.
- If a concern becomes a likely bug, switch briefly into code-review mode and
  state severity, impact, and the exact code location.
- Separate confirmed findings from questions, hypotheses, and preferences. Do
  not present a concern as a finding unless it is supported by code evidence.

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

## Verification

When verification would materially affect confidence, suggest or run the
smallest relevant command if allowed. If verification is not run, say exactly
what remains unverified.

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
Use severity only for evidence-backed findings, not for style preferences or
open questions.

## Completion

End with a compact review state that helps the human decide what to do next:

- Topics covered.
- Topics not yet covered.
- Findings, if any, ordered by severity.
- Open questions or unresolved risks.
- Verification performed or still missing.
- Whether the human appears ready to accept, request changes, or continue review.

Do not claim full approval if important verification was not run or if the
reviewer stopped before all groups were covered.
Do not claim approval on the human's behalf.
