# DevFlow Plugin

Development workflow automation for git and GitHub operations. Streamlines common development tasks with intelligent slash commands.

## Version

0.0.1

## Commands

### `/devflow:commit [flags]`

Create a conventional commit with an auto-generated commit message.

**Features:**
- Analyzes staged and unstaged changes
- Generates conventional commit messages following [conventionalcommits.org](https://conventionalcommits.org) v1.0.0
- Supports all git commit flags (e.g., `--no-verify`, `--amend`)
- References recent commits for consistent style

**Usage:**
```bash
# Basic usage
/devflow:commit

# With flags
/devflow:commit --no-verify

# Amend previous commit
/devflow:commit --amend
```

**Commit Format:**
```
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

**Types:** feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

---

### `/devflow:ensure-pr [flags]`

Create a new pull request or update an existing one with current changes.

**Features:**
- Creates new PR with comprehensive title and description
- Updates existing PR title and description with latest changes
- Analyzes ALL commits and full diff since branch diverged from main
- Automatically pushes branch if needed
- Supports GitHub CLI flags (e.g., `--draft`, `--web`)

**Usage:**
```bash
# Create or update PR
/devflow:ensure-pr

# Create draft PR
/devflow:ensure-pr --draft

# Open PR in browser
/devflow:ensure-pr --web
```

**PR Description Format:**
```markdown
## Summary
- Main change 1
- Main change 2
- Main change 3

## Test Plan
- [ ] Test case 1
- [ ] Test case 2
- [ ] Test case 3
```

---

### `/devflow:review`

Review staged changes for potential issues before committing.

**Features:**
- Analyzes code quality and best practices
- Checks for bugs and logical errors
- Reviews error handling and security
- Validates testing and documentation
- Provides actionable feedback with file:line references

**Usage:**
```bash
# Review staged changes
/devflow:review
```

**Review Areas:**
- Code Quality: bugs, maintainability, naming
- Best Practices: conventions, error handling, security
- Testing: test coverage, edge cases
- Documentation: comments, API docs
- Performance: optimization opportunities

**Output:**
```markdown
## Review Summary
Overall Assessment: [Ready/Needs fixes/Has suggestions]

## Issues Found
### Critical (must fix)
### Important (should fix)
### Suggestions (nice to have)

## Positive Observations
## Recommendation
```

---

### `/devflow:review-pr [pr-number]`

Review a GitHub pull request with comprehensive analysis.

**Features:**
- Fetches PR details and diff from GitHub
- Checks out PR branch locally for user inspection
- Reviews code quality, bugs, and best practices
- Checks CI/test status
- Provides structured feedback with specific file:line references

**Usage:**
```bash
# Review PR #123
/devflow:review-pr 123

# Review current branch's PR
/devflow:review-pr
```

**Review Process:**
1. Fetches PR information from GitHub
2. Checks out PR branch locally (if possible)
3. Analyzes full diff and changed files
4. Reviews against quality checklist
5. Provides structured feedback

**Output:**
```markdown
## PR Review: [Title]
PR Number: #123
Author: [author]
Status: [status]
CI Checks: [status]
Branch: [checked out locally / reviewed remotely]

### Overall Assessment
### Issues Found (Critical/Important/Suggestions)
### Positive Observations
### Recommendation
```

---

## Installation

This plugin is part of your dotfiles. Commands are available in any project where you use Claude Code.

To use the plugin:

1. Ensure the plugin is in your `.claude/plugins/devflow/` directory
2. Launch Claude Code in any project
3. Use commands with `/devflow:` prefix

## Typical Workflow

### Starting a feature:
```bash
# Make changes
git add .
/devflow:review          # Review before committing
/devflow:commit          # Create conventional commit
```

### Creating a PR:
```bash
# Make more commits
/devflow:ensure-pr       # Create PR with auto-generated description
```

### Updating a PR:
```bash
# Make more changes and commits
/devflow:ensure-pr       # Updates existing PR title and description
```

### Reviewing a PR:
```bash
/devflow:review-pr 123   # Review PR #123 locally
```

## Requirements

- Git
- GitHub CLI (`gh`) for PR operations
- Claude Code

## Author

Roman Kuznetsov

## License

Part of personal dotfiles

## Contributing

This is a personal plugin. Feel free to fork and adapt for your own needs.

## Version History

### 0.0.1 (2025-10-20)
- Initial release
- Commands: commit, ensure-pr, review, review-pr
- Conventional Commits support
- GitHub PR automation
- Code review capabilities
