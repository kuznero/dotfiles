{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    editorconfig.enable = true;
    colorschemes.catppuccin.enable = true;

    opts = {
      autoindent = true;
      breakindent = true;
      cursorline = false;
      expandtab = true;
      hlsearch = true;
      ignorecase = true;
      incsearch = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      smartcase = true;
      smartindent = true;
      softtabstop = 2;
      swapfile = false;
      tabstop = 2;
      termguicolors = true;
      undofile = true;
      updatetime = 50; # Faster completion
      wrap = false;
    };

    # ref: https://nix-community.github.io/nixvim/index.html
    plugins = {
      bufferline.enable = true;
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp.enable = true;
      cmp_luasnip.enable = true;
      conform-nvim.enable = true;
      dressing.enable = true;
      flash.enable = true;
      friendly-snippets.enable = true;
      gitsigns.enable = true;
      illuminate.enable = true;
      indent-blankline.enable = true;
      lazy.enable = true;
      lint.enable = true;
      # lsp.servers = {
      #   gopls = {
      #     enable = true;
      #     autostart = true;
      #     # extraOptions.settings = {
      #     #   gopls = {
      #     #     staticcheck = true;
      #     #     directoryFilters = [
      #     #       "-.git"
      #     #       "-.vscode"
      #     #     ];
      #     #     semanticTokens = true;
      #     #     analyses = {
      #     #       fieldalignment = true;
      #     #       useany = true;
      #     #     };
      #     #   };
      #     # };
      #   };
      #   yamlls.enable = true;
      # };
      lualine.enable = true;
      neo-tree.enable = true;
      nix-develop.enable = true;
      nix.enable = true;
      noice.enable = true;
      notify.enable = true;
      persistence.enable = true;
      spectre.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>g" = {
            action = "live_grep";
            options = {
              desc = "Telescope Live Grep";
            };
          };
          "<leader>p" = {
            action = "find_files";
            options = {
              desc = "Telescope Find Files";
            };
          };
          "<leader>b" = {
            action = "buffers";
            options = {
              desc = "Telescope Buffers";
            };
          };
          "<leader>k" = {
            action = "keymaps";
            options = {
              desc = "Telescope Keymaps";
            };
          };
        };
      };
      todo-comments.enable = true;
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml
        ];
      };
      treesitter-context.enable = true;
      treesitter-textobjects.enable = true;
      trouble.enable = true;
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
    };
  };
}
