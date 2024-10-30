{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs; [ gotools gofumpt delve ];

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
      lsp = {
        enable = true;
        servers = {
          gopls = {
            enable = true;
            autostart = true;
            package = null; # ref: https://github.com/nix-community/nixvim/discussions/1442
            extraOptions.settings.gopls = {
              gofumpt = true;
              codelenses = {
                gc_details = false;
                generate = true;
                regenerate_cgo = true;
                run_govulncheck = true;
                test = true;
                tidy = true;
                upgrade_dependency = true;
                vendor = true;
              };
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                compositeLiteralTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
              analyses = {
                fieldalignment = true;
                nilness = true;
                unusedparams = true;
                unusedwrite = true;
                useany = true;
              };
              usePlaceholders = true;
              completeUnimported = true;
              staticcheck = true;
              directoryFilters = ["-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules"];
              semanticTokens = true;
            };
          };
          yamlls.enable = true;
        };
      };
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
          "gd" = {
            action = "lsp_definitions";
            options = {
              desc = "Telescope LSP Definitions";
            };
          };
          "gr" = {
            action = "lsp_references";
            options = {
              desc = "Telescope LSP References";
            };
          };
        };
      };
      todo-comments.enable = true;
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          go
          gomod
          gosum
          gowork
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
