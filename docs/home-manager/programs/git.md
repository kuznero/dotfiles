# Git Configuration

Comprehensive Git setup with custom aliases, delta diff viewer, and
productivity enhancements.

## Features

- **Delta**: Syntax-highlighting pager for git diffs
- **Custom Aliases**: Shortcuts for common workflows
- **GPG Signing**: Commit signature verification
- **LFS Support**: Large file storage
- **Catppuccin Theme**: Consistent visual styling

## Configuration Location

`home-manager/programs/git.nix`

## Key Aliases

### Basic Operations

- `s` - Status
- `a` - Add with patch mode
- `c` - Commit
- `cm` - Commit with message
- `ca` - Commit amend
- `ac` - Add all and commit
- `acm` - Add all and commit with message

### Branch Management

- `b` - Branch list
- `bd` - Delete branch
- `bdd` - Force delete branch
- `sw` - Switch branch
- `swc` - Create and switch branch
- `swm` - Switch to main branch

### History & Diffs

- `d` - Diff
- `ds` - Diff staged
- `l` - Pretty log
- `lo` - Oneline log
- `lg` - Graph log
- `last` - Show last commit

### Remote Operations

- `p` - Pull
- `ps` - Push
- `psf` - Force push
- `psu` - Push with upstream
- `f` - Fetch

### Advanced Features

- `rb` - Rebase
- `rbi` - Interactive rebase
- `cp` - Cherry-pick
- `st` - Stash
- `undo` - Undo last commit

## Delta Configuration

Delta provides enhanced diff viewing with:

- Syntax highlighting
- Line numbers
- Side-by-side view option
- File navigation
- Catppuccin color scheme

### Usage

```bash
# Regular diff with delta
git diff

# Side-by-side diff
git diff --side-by-side

# Navigate between files
git diff | less
# Use n/N to jump between files
```

## GPG Signing

If GPG signing is configured:

- Commits are automatically signed
- Signature verification on pull
- GPG key must be configured in Git

## Git LFS

Large File Storage enabled for:

- Binary assets
- Large data files
- Media files

## Custom Scripts

### gcauto

Automated commit with AI-generated messages:

```bash
# Stage and commit with auto-generated message
gcauto

# With custom prefix
gcauto "feat: "
```

Located at: `home-manager/programs/scripts/gcauto`

## Tips

1. **Quick Status**: Use `git s` for fast status checks
2. **Interactive Add**: `git a` for selective staging
3. **Pretty Logs**: `git lg` for visual branch history
4. **Undo Commits**: `git undo` keeps changes staged

## Integration

Works seamlessly with:

- Nixvim fugitive plugin
- VS Code Git integration
- Terminal prompts showing Git status
- GitHub CLI (gh) for PR management
