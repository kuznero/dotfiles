---
allowed-tools: Bash(git status:*), Bash(git diff:*), Read, Glob, Grep
description: Review staged changes before committing
---

## Context

- Current git status: !`git status`
- Staged changes: !`git diff --cached`
- Unstaged changes: !`git diff`

## Your Task

Review the staged (and unstaged if any) changes for potential issues before committing.

### Review Checklist:

1. **Code Quality:**
   - Are there any obvious bugs or logical errors?
   - Is the code clear and maintainable?
   - Are variable/function names descriptive?
   - Is there unnecessary complexity?

2. **Best Practices:**
   - Does the code follow project conventions?
   - Are there proper error handling mechanisms?
   - Are there any security concerns?
   - Is there duplicated code that could be refactored?

3. **Testing:**
   - Are there corresponding tests for new functionality?
   - Do existing tests need updates?
   - Are edge cases covered?

4. **Documentation:**
   - Are complex parts of the code documented?
   - Do public APIs have proper documentation?
   - Are comments accurate and helpful (avoid stating the obvious)?

5. **Performance:**
   - Are there any obvious performance issues?
   - Could any operations be optimized?
   - Are there unnecessary operations or allocations?

### Output Format:

Provide a structured review with:

```markdown
## Review Summary

**Overall Assessment:** [Ready to commit / Needs fixes / Has suggestions]

## Issues Found

### Critical (must fix before committing):
- [file:line] Issue description

### Important (should fix):
- [file:line] Issue description

### Suggestions (nice to have):
- [file:line] Suggestion

## Positive Observations

- What's well done in these changes

## Recommendation

[Clear action items or approval to proceed]
```

### Instructions:

- Read the relevant changed files if needed to understand context
- Focus on the actual changes (the diff), not the entire files
- Be specific with file:line references
- Be constructive and actionable
- Prioritize critical issues over minor style preferences
