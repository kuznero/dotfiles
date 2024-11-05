{ inputs, pkgs, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs; [ gotools gofumpt delve ];

    globals = {
      mapleader = "\\";
      maplocalleader = "\\";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = ":Neotree<CR>";
      }
      {
        mode = "n";
        key = "<leader>g";
        action = ":LazyGit<CR>";
      }
      {
        mode = "n";
        key = "<esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "<leader>t";
        action = ":FloatermToggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>z";
        action = ":Twilight<CR>";
      }
    ];

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
      barbar = {
        enable = true;
        settings = {
          animation = true;
          auto_hide = false;
          clickable = true;
          focus_on_close = "left";
          insert_at_end = false;
          insert_at_start = false;
          maximum_length = 30;
          maximum_padding = 2;
          minimum_padding = 1;
          no_name_title = "[No Name]";
        };
        keymaps = {
          close.key = "<C-c>";
          goTo1.key = "<C-1>";
          goTo2.key = "<C-2>";
          goTo3.key = "<C-3>";
          goTo4.key = "<C-4>";
          goTo5.key = "<C-5>";
          goTo6.key = "<C-6>";
          goTo7.key = "<C-7>";
          goTo8.key = "<C-8>";
          goTo9.key = "<C-9>";
          last.key = "<C-0>";
          previous.key = "<S-Tab>";
          next.key = "<Tab>";
          movePrevious.key = "<C-,>";
          moveNext.key = "<C-.>";
        };
      };
      bufferline.enable = true;
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "nvim_lsp_document_symbol"; }
            { name = "luasnip"; } # For luasnip users.
            { name = "path"; }
            { name = "buffer"; }
            { name = "cmdline"; }
            { name = "spell"; }
            { name = "dictionary"; }
            { name = "treesitter"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      cmp_luasnip.enable = true;
      conform-nvim.enable = true;
      dressing.enable = true;
      flash.enable = true;
      floaterm = {
        enable = true;
        width = 0.8;
        height = 0.8;
        keymaps.toggle = "<leader>t";
      };
      friendly-snippets.enable = true;
      gitsigns.enable = true;
      illuminate.enable = true;
      indent-blankline.enable = true;
      lazy.enable = true;
      lazygit.enable = true;
      lint.enable = true;
      lsp = {
        enable = true;
        servers = {
          gopls = {
            enable = true;
            autostart = true;
            package =
              null; # ref: https://github.com/nix-community/nixvim/discussions/1442
            extraOptions.settings.gopls = {
              buildFlags = [ "-tags=unit,integration" ];
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
              directoryFilters =
                [ "-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules" ];
              semanticTokens = true;
            };
          };
          yamlls.enable = true;
        };
      };
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources.formatting.nixfmt.enable = true;
        sources.formatting.gofumpt.enable = true;
      };
      lualine.enable = true;
      neo-tree = {
        enable = true;
        autoCleanAfterSessionRestore = true;
        closeIfLastWindow = true;
        window.position = "left";
        filesystem = {
          followCurrentFile.enabled = true;
          filteredItems = {
            hideHidden = false;
            hideDotfiles = false;
            forceVisibleInEmptyFolder = true;
            hideGitignored = false;
          };
        };
        defaultComponentConfigs = {
          diagnostics = {
            symbols = {
              hint = "";
              info = "";
              warn = "";
              error = "";
            };
            highlights = {
              hint = "DiagnosticSignHint";
              info = "DiagnosticSignInfo";
              warn = "DiagnosticSignWarn";
              error = "DiagnosticSignError";
            };
          };
        };
      };
      nix-develop.enable = true;
      nix.enable = true;
      noice.enable = true;
      notify.enable = true;
      persistence.enable = true;
      spectre.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>/" = {
            action = "live_grep";
            options = { desc = "Telescope Live Grep"; };
          };
          "<leader>p" = {
            action = "find_files";
            options = { desc = "Telescope Find Files"; };
          };
          "<leader>b" = {
            action = "buffers";
            options = { desc = "Telescope Buffers"; };
          };
          "<leader>k" = {
            action = "keymaps";
            options = { desc = "Telescope Keymaps"; };
          };
          "gd" = {
            action = "lsp_definitions";
            options = { desc = "Telescope LSP Definitions"; };
          };
          "gr" = {
            action = "lsp_references";
            options = { desc = "Telescope LSP References"; };
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
        settings.auto_install = true;
      };
      treesitter-context.enable = true;
      treesitter-textobjects.enable = true;
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
          auto_fold = false;
          auto_open = false;
          auto_preview = false;
          auto_refresh = true;
        };
      };
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
      twilight.enable = true;
      web-devicons.enable = true;
      which-key = {
        enable = true;
        settings = {
          delay = 200;
          expand = 1;
          notify = false;
          preset = false;
          replace = {
            desc = [
              [ "<space>" "SPACE" ]
              [ "<leader>" "SPACE" ]
              [ "<[cC][rR]>" "RETURN" ]
              [ "<[tT][aA][bB]>" "TAB" ]
              [ "<[bB][sS]>" "BACKSPACE" ]
            ];
          };
          spec = [
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffers";
              icon = "󰓩 ";
            }
            {
              __unkeyed-1 = "<leader>g";
              group = "LazyGit";
            }
            {
              __unkeyed-1 = "<leader>e";
              group = "Neo-Tree";
            }
            {
              __unkeyed-1 = "<leader>t";
              group = "Floatterm";
            }
            {
              __unkeyed-1 = "<leader>z";
              group = "Twilight";
            }
            {
              __unkeyed = "<leader>c";
              group = "Codesnap";
              icon = "󰄄 ";
              mode = "v";
            }
            {
              __unkeyed-1 = "<leader>bs";
              group = "Sort";
              icon = "󰒺 ";
            }
            {
              __unkeyed-1 = [
                {
                  __unkeyed-1 = "<leader>f";
                  group = "Normal Visual Group";
                }
                {
                  __unkeyed-1 = "<leader>f<tab>";
                  group = "Normal Visual Group in Group";
                }
              ];
              mode = [ "n" "v" ];
            }
            {
              __unkeyed-1 = "<leader>w";
              group = "windows";
              proxy = "<C-w>";
            }
            {
              __unkeyed-1 = "<leader>cS";
              __unkeyed-2 = "<cmd>CodeSnapSave<CR>";
              desc = "Save";
              mode = "v";
            }
            {
              __unkeyed-1 = "<leader>db";
              __unkeyed-2 = {
                __raw = ''
                  function()
                    require("dap").toggle_breakpoint()
                  end
                '';
              };
              desc = "Breakpoint toggle";
              mode = "n";
              silent = true;
            }
          ];
          win = { border = "single"; };
        };
      };
    };
  };
}
