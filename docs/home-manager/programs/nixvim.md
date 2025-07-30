# Nixvim Configuration

A powerful Neovim distribution configured through Nix with LSP support, AI
integration, and modern plugins.

## Features

- **LSP Support**: Language servers for multiple languages
- **AI Integration**: Ollama-powered code completion
- **Git Integration**: Fugitive and Gitsigns
- **File Navigation**: Telescope fuzzy finder and file tree
- **Catppuccin Theme**: Beautiful and consistent styling
- **Tmux Integration**: Seamless navigation between panes

## Configuration

The Nixvim module is parameterized for different setups:

```nix
# Moon/WSL configuration (1.5b model)
(import ./home-manager/programs/nixvim.nix {
  inputs = inputs;
  pkgs = nixpkgs-unstable.legacyPackages.${system};
  system = system;
  ollamaModel = "qwen2.5-coder:1.5b";
})

# Mac configuration (7b model)
ollamaModel = "qwen2.5-coder:7b";
```

## Key Mappings

### General

- `<Space>` - Leader key
- `<C-s>` - Save file
- `<leader>q` - Quit

### Navigation

- `<C-h/j/k/l>` - Navigate between windows/tmux panes
- `<leader>e` - Toggle file explorer
- `gd` - Go to definition
- `gr` - Find references

### Telescope (Fuzzy Finding)

- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Browse buffers
- `<leader>fh` - Help tags

### Git (Fugitive)

- `<leader>gs` - Git status
- `<leader>gc` - Git commit
- `<leader>gp` - Git push
- `<leader>gl` - Git log

### LSP

- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `[d`/`]d` - Navigate diagnostics

### AI Completion

- `<Tab>` - Accept completion
- `<C-Space>` - Trigger completion manually

## Language Support

### Built-in LSP Servers

- **Nix** - nil
- **Python** - pyright
- **TypeScript/JavaScript** - ts_ls
- **Rust** - rust-analyzer
- **Go** - gopls
- **C/C++** - clangd
- **Lua** - lua-ls
- **Markdown** - marksman
- **YAML** - yamlls
- **JSON** - jsonls
- **Bash** - bashls

### Syntax Highlighting

Tree-sitter provides advanced syntax highlighting for all supported languages.

## Plugins

### Core Editing

- **nvim-autopairs** - Auto-close brackets
- **vim-surround** - Manipulate surroundings
- **comment.nvim** - Smart commenting
- **indent-blankline** - Indentation guides

### UI Enhancements

- **lualine** - Status line
- **bufferline** - Buffer tabs
- **noice** - Better command line
- **which-key** - Keybinding hints

### Development Tools

- **trouble.nvim** - Diagnostics list
- **todo-comments** - Highlight TODOs
- **git-conflict** - Conflict resolution
- **conform.nvim** - Auto-formatting

## AI Integration

Ollama integration provides:

- Intelligent code completion
- Context-aware suggestions
- Multiple model support
- Local processing (no cloud dependency)

Model selection based on system:

- **1.5b model**: Faster, less resource intensive (Linux/WSL)
- **7b model**: More capable, better suggestions (Mac)

## Customization

### Adding Languages

To add a new language server:

1. Add to `servers` list in nixvim.nix
2. Configure specific settings if needed
3. Rebuild configuration

### Changing Keybindings

Modify keymaps in the nixvim configuration:

```nix
keymaps = [
  {
    mode = "n";
    key = "<your-key>";
    action = "<your-action>";
  }
];
```

### Plugin Configuration

Each plugin can be configured in its respective section:

```nix
plugins.telescope = {
  enable = true;
  settings = {
    # Custom settings
  };
};
```

## Tips

1. **Quick File Switch**: Use `<leader>ff` for fast file navigation
2. **Global Search**: `<leader>fg` to search across project
3. **LSP Actions**: `<leader>ca` for quick fixes and refactoring
4. **Git Integration**: `<leader>gs` for interactive git status

## Troubleshooting

### LSP Not Working

- Check if language server is installed
- Verify file type detection
- Look at `:LspInfo` for status

### Slow Performance

- Switch to smaller AI model
- Disable unused plugins
- Check for conflicting configurations

### Key Conflicts

- Use `:map <key>` to check mappings
- Which-key shows available combinations
- Modify conflicting mappings in config

