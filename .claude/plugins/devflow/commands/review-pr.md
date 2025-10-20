---
allowed-tools: Bash(gh pr:*), Bash(git checkout:*), Bash(git fetch:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Read, Glob, Grep
description: Review a GitHub pull request
argument-hint: "[pr-number]"
---

## Your Task

Review a GitHub pull request for code quality, bugs, and best practices.

**Arguments:** $ARGUMENTS (required: PR number)

### Workflow:

1. **Fetch PR details:**
   - Use `gh pr view [pr-number]` to get PR information
   - Use `gh pr diff [pr-number]` to get the full diff
   - Use `gh pr checks [pr-number]` to see CI/test status

2. **Checkout PR branch locally:**
   - Use `gh pr checkout [pr-number]` to switch to the PR's branch
   - This allows the user to see the changes locally and test them
   - If checkout fails (e.g., local changes), inform the user and continue with remote review

3. **Analyze the changes:**
   - Review the full diff from the PR
   - Use `git diff main...HEAD` to see the changes if checked out locally
   - Read relevant files if more context is needed
   - Consider the PR description and purpose

4. **Review Checklist:**

   **Code Quality:**
   - Are there any obvious bugs or logical errors?
   - Is the code clear and maintainable?
   - Are variable/function names descriptive?
   - Is there unnecessary complexity?

   **Best Practices:**
   - Does the code follow project conventions?
   - Are there proper error handling mechanisms?
   - Are there any security concerns?
   - Is there duplicated code that could be refactored?

   **Testing:**
   - Are there corresponding tests for new functionality?
   - Do existing tests need updates?
   - Are edge cases covered?
   - Did CI checks pass?

   **Documentation:**
   - Are complex parts of the code documented?
   - Do public APIs have proper documentation?
   - Are comments accurate and helpful?
   - Is the PR description clear and complete?

   **Performance:**
   - Are there any obvious performance issues?
   - Could any operations be optimized?

5. **Output Format:**

   ```markdown
   ## PR Review: [PR Title]

   **PR Number:** #[number]
   **Author:** [author]
   **Status:** [open/draft/etc]
   **CI Checks:** [passing/failing/pending]
   **Branch:** [checked out locally / reviewed remotely]

   ### Overall Assessment
   [Ready to merge / Needs changes / Looks good with minor suggestions]

   ### Issues Found

   #### Critical (must fix before merging):
   - [file:line] Issue description and suggested fix

   #### Important (should fix):
   - [file:line] Issue description and suggested fix

   #### Suggestions (nice to have):
   - [file:line] Suggestion for improvement

   ### Positive Observations
   - What's well done in this PR

   ### Recommendation
   [Clear action items: approve, request changes, or comment]
   ```

### Instructions:

- Always attempt to checkout the PR branch locally first for better inspection
- Be thorough but focus on significant issues
- Provide specific file:line references
- Offer constructive suggestions with reasoning
- Consider the PR's stated purpose and scope
- Balance criticism with positive feedback
- Be actionable: tell the author what to do next
