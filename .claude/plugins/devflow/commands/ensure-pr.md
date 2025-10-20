---
allowed-tools: Bash(git checkout:*), Bash(git branch:*), Bash(git status:*), Bash(git push:*), Bash(git log:*), Bash(git diff:*), Bash(gh pr:*)
description: Create or update a GitHub pull request
argument-hint: "[pr-flags]"
---

## Context

- Current git status: !`git status`
- Current branch: !`git branch --show-current`
- Main branch: !`git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
- Commits since divergence: !`git log --oneline $(git merge-base HEAD origin/$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'))..HEAD`

## Your Task

Create a new GitHub pull request or update an existing one for the current branch.

**Arguments:** $ARGUMENTS (optional flags like --draft, --web)

### Workflow:

1. **Check for existing PR:**
   - Run `gh pr view` to check if PR already exists for this branch
   - If exists, analyze ALL current changes and update the PR title and description to reflect recent updates

2. **If no PR exists:**
   - Ensure we're not on the main branch
   - If on main, create a new feature branch first
   - Push the branch to origin with `-u` flag if not already tracking remote

3. **Analyze changes:**
   - Review ALL commits since the branch diverged from main (not just the latest commit)
   - Review the full diff from main: `git diff $(git merge-base HEAD origin/main)..HEAD`
   - Generate comprehensive PR title and description based on all changes

4. **PR Description Format:**
   ```markdown
   ## Summary
   - [Bullet point of main change 1]
   - [Bullet point of main change 2]
   - [Bullet point of main change 3]

   ## Test Plan
   - [ ] Test case 1
   - [ ] Test case 2
   - [ ] Test case 3
   ```

5. **Create or update the PR:**
   - **New PR:** Use `gh pr create --title "..." --body "..."`
   - **Existing PR:** Use `gh pr edit --title "..." --body "..."` to update with latest changes
   - Pass any additional arguments from $ARGUMENTS
   - Return the PR URL when done

### Important Notes:

- ALWAYS analyze the FULL diff from main, not just the latest commit
- For existing PRs, ALWAYS update title and description to reflect recent changes
- Generate meaningful, descriptive PR title (not just the commit message)
- Include actionable test plan items
- You have the capability to call multiple tools in a single response - use it efficiently
- Only send tool calls, no other text or messages
