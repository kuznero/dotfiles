{ inputs, pkgs, ... }:

# NOTE: after installing nixvim, start it, and run `checkhealth` command to ensure no errors.
# NOTE: sometimes, it might be required to run `TSUpdate` command to clear some of the errors/warnings.

{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  home.packages = with pkgs; [ chafa ueberzugpp viu ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    # Go tools removed - should be provided by project devShell
    # to avoid Go version conflicts: gotools, gofumpt, delve

    # ref: https://vimcolorschemes.com/
    extraPlugins = with pkgs; [
      vimPlugins.ayu-vim
      # vimPlugins.base16-nvim
      vimPlugins.catppuccin-nvim
      vimPlugins.dracula-nvim
      vimPlugins.everforest
      vimPlugins.gruvbox-nvim
      vimPlugins.kanagawa-nvim
      vimPlugins.melange-nvim
      vimPlugins.monokai-pro-nvim
      vimPlugins.monokai-pro-nvim
      vimPlugins.neomodern-nvim
      vimPlugins.nightfox-nvim
      vimPlugins.oceanic-material
      vimPlugins.oceanic-next
      vimPlugins.onedark-nvim
      vimPlugins.oxocarbon-nvim
      vimPlugins.vscode-nvim
    ];

    autoCmd = [{
      event = "FileType";
      pattern = [ "helm" ];
      command = "LspRestart";
      desc =
        "ref: https://github.com/nix-community/nixvim/issues/989#issuecomment-2333728503";
    }];

    globals = {
      mapleader = "\\";
      maplocalleader = "\\";
    };

    diagnostic = {
      settings = {
        # NOTE: Opt-in with 0.11
        virtual_text = {
          severity.min = "warn";
          source = "if_many";
        };
        # virtual_lines = { current_line = true; };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>a";
        action = "<cmd>AerialToggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>AerialNavToggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>c";
        action = "<cmd>CodeCompanionActions<CR>";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree<CR>";
      }
      {
        mode = "n";
        key = "<leader>G";
        action = "<cmd>LazyGit<CR>";
      }
      {
        mode = "n";
        key = "<esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "<leader>t";
        action = "<cmd>Telescope<CR>";
      }
      {
        mode = "n";
        key = "<leader>z";
        action = "<cmd>Twilight<CR>";
      }
      {
        mode = "n";
        key = "<f7>";
        action = ":DapToggleRepl<cr>";
        options = {
          silent = true;
          desc = "Dap: Toggle REPL";
        };
      }
      {
        mode = "n";
        key = "<f9>";
        action = ":DapToggleBreakpoint<cr>";
        options = {
          silent = true;
          desc = "Dap: Toggle Breakpoint";
        };
      }
      {
        mode = "n";
        key = "<f21>"; # shift-f9
        action = ":DapClearBreakpoints<cr>";
        options = {
          silent = true;
          desc = "Dap: Clear Breakpoints";
        };
      }
      {
        mode = "n";
        key = "<f5>";
        action = ":DapContinue<cr>";
        options = {
          silent = true;
          desc = "Dap: Continue";
        };
      }
      {
        mode = "n";
        key = "<f11>";
        action = ":DapStepInto<cr>";
        options = {
          silent = true;
          desc = "Dap: Step into";
        };
      }
      {
        mode = "n";
        key = "<f23>"; # shift-f11
        action = ":DapStepOut<cr>";
        options = {
          silent = true;
          desc = "Dap: Step Out";
        };
      }
      {
        mode = "n";
        key = "<f10>";
        action = ":DapStepOver<cr>";
        options = {
          silent = true;
          desc = "Dap: Step Over";
        };
      }
      {
        mode = "n";
        key = "<f5>";
        action = ":DapNew<cr>";
        options = {
          silent = true;
          desc = "Dap: Start";
        };
      }
      {
        mode = "n";
        key = "<f17>"; # shift-f5
        action = ":DapTerminate<cr>";
        options = {
          silent = true;
          desc = "Dap: Terminate";
        };
      }
      # Unmap Neovim's built-in comment keymaps to avoid conflicts with Comment.nvim
      {
        mode = [ "n" "x" ];
        key = "gc";
        action = "<Nop>";
      }
      {
        mode = [ "n" "x" ];
        key = "gb";
        action = "<Nop>";
      }
      {
        mode = "n";
        key = "gcc";
        action = "<Nop>";
      }
      {
        mode = "n";
        key = "gbc";
        action = "<Nop>";
      }
      # Diagnostic navigation
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options = { desc = "Go to next diagnostic"; };
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options = { desc = "Go to previous diagnostic"; };
      }
      # Gitsigns hunk navigation
      {
        mode = "n";
        key = "]c";
        action = "<cmd>Gitsigns next_hunk<CR>";
        options = { desc = "Go to next git hunk"; };
      }
      {
        mode = "n";
        key = "[c";
        action = "<cmd>Gitsigns prev_hunk<CR>";
        options = { desc = "Go to previous git hunk"; };
      }
      # Gopls build tags discovery
      {
        mode = "n";
        key = "<leader>gt";
        action = "<cmd>GoplsDiscoverTags<CR>";
        options = { desc = "Discover Go build tags"; };
      }
      # Git worktree operations
      {
        mode = "n";
        key = "<leader>gw";
        action = "<cmd>Telescope git_worktree git_worktree<CR>";
        options = { desc = "List and switch git worktrees"; };
      }
      {
        mode = "n";
        key = "<leader>gW";
        action = "<cmd>Telescope git_worktree create_git_worktree<CR>";
        options = { desc = "Create new git worktree"; };
      }
    ];

    editorconfig.enable = true;
    colorschemes = { catppuccin.enable = true; };
    # colorscheme set dynamically in extraConfigLua based on ~/.config/appearance

    opts = {
      autoindent = true;
      breakindent = true;
      cursorline = true;
      colorcolumn = "80";
      endofline = false;
      expandtab = true;
      foldenable = false;
      fileformat = "unix";
      fileformats = [ "unix" "dos" ];
      hlsearch = true;
      ignorecase = true;
      incsearch = true;
      list = false;
      listchars = "tab:⇥ ,trail:.,nbsp:␣,space:.,eol:󱞣";
      number = true;
      relativenumber = false;
      shiftwidth = 2;
      smartcase = true;
      smartindent = true;
      softtabstop = 2;
      swapfile = false;
      tabstop = 2;
      termguicolors = true;
      undofile = true;
      updatetime = 50; # Faster completion
      winbar = "";
      wrap = false;
    };

    # ref: https://nix-community.github.io/nixvim/index.html
    plugins = {
      aerial.enable = true;
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
      blink-cmp = {
        enable = true;
        settings = {
          appearance = {
            nerd_font_variant = "normal";
            use_nvim_cmp_as_default = true;
          };
          completion = {
            accept = {
              auto_brackets = {
                enabled = true;
                semantic_token_resolution = { enabled = false; };
              };
            };
            documentation = { auto_show = true; };
          };
          keymap = { preset = "super-tab"; };
          signature = { enabled = true; };
          sources = {
            cmdline = [ ];
            providers = {
              buffer = { score_offset = -7; };
              lsp = { fallbacks = [ ]; };
            };
          };
        };
      };
      cmp = {
        enable = false;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "nvim_lsp_document_symbol"; }
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
      cmp-dap.enable = false;
      conform-nvim.enable = true;
      dap = {
        enable = true;
        adapters = { };
        signs = {
          dapBreakpoint = {
            text = "●";
            texthl = "DapBreakpoint";
          };
          dapBreakpointCondition = {
            text = "●";
            texthl = "DapBreakpointCondition";
          };
          dapLogPoint = {
            text = "◆";
            texthl = "DapLogPoint";
          };
        };
      };
      dap-go.enable = true;
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
      comment.enable = true;
      coverage.enable = true;
      dressing.enable = true;
      git-worktree = {
        enable = true;
        enableTelescope = true;
      };
      gitsigns = {
        enable = true;
        settings = {
          base = "origin/main";
          signs = {
            add = { text = "│"; };
            change = { text = "│"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
            untracked = { text = "┆"; };
          };
          linehl = true;
          current_line_blame = true;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 1000;
          };
        };
      };
      lazygit.enable = true;
      helm.enable = true;
      lint = {
        enable = true;
        lintersByFt = {
          # Explicitly configure linters to avoid auto-detection of vale
          markdown = [ "markdownlint" ];
          yaml = [ "yamllint" ];
          dockerfile = [ "hadolint" ];
          go = [ "golangcilint" ];
          terraform = [ "tflint" ];
          json = [ "jsonlint" ];
          sh = [ "shellcheck" ];
          bash = [ "shellcheck" ];
          python = [ "mypy" ];
        };
      };
      lsp = {
        enable = true;
        servers = {
          gopls = {
            # Disabled - manually configured in extraConfigLua to avoid bundling Go
            # Actual configuration is at the bottom of this file in extraConfigLua
            enable = false;
          };
          helm_ls.enable = true;
          buf_ls = {
            enable = true;
            autostart = true;
          };
          terraformls = {
            enable = true;
            autostart = true;
          };
          tflint = {
            enable = true;
            autostart = true;
          };
          ts_ls = {
            enable = true;
            autostart = true;
          };
          basedpyright = {
            enable = true;
            autostart = true;
            rootMarkers = [ "pyproject.toml" ];
          };
          ruff = {
            enable = true;
            autostart = true;
          };
          yamlls.enable = true;
          zls.enable = true;
        };
      };
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          # Only enable icons module
          icons = { };
        };
      };
      mkdnflow = {
        enable = true;
        settings = {
          mappings = {
            MkdnTableFormat = {
              key = "<leader>ft";
              modes = [ "n" ];
            };
          };
          yaml = { bib = { override = false; }; };
          tables = {
            trim_whitespace = true;
            format_on_move = true;
            auto_extend_rows = false;
            auto_extend_cols = false;
          };
          toDo = {
            symbols = [ " " "-" "X" ];
            update_parents = true;
            not_started = " ";
            in_progress = "-";
            complete = "X";
          };
          links = {
            style = "markdown";
            conceal = false;
            context = 0;
            implicit_extension = null;
            transform_explicit = false;
            transform_implicit = ''
              function(text)
                text = text:gsub(" ", "-")
                text = text:lower()
                text = os.date('%Y-%m-%d_')..text
                return(text)
              end
            '';
          };
          silent = false;
          bib = {
            default_path = null;
            find_in_root = true;
          };
          wrap = true; # Disabled - let autocmds handle wrap setting
          perspective = {
            priority = "first";
            fallback = "first";
            root_tell = false;
            nvim_wd_heel = false;
            update = true;
          };
          createDirs = true;
          filetypes = {
            md = true;
            rmd = true;
            markdown = true;
          };
          modules = {
            bib = true;
            buffers = true;
            conceal = true;
            cursor = true;
            folds = true;
            links = true;
            lists = true;
            maps = false;
            paths = true;
            tables = true;
            yaml = false;
          };
        };
      };
      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources = {
          code_actions = {
            gomodifytags.enable = true;
            impl.enable = true;
            # ts_node_action.enable = true;
          };
          diagnostics = {
            buf.enable = true;
            mypy.enable = true;
            golangci_lint = {
              enable = true;
              package = null;
              settings = {
                extra_args = {
                  __raw = ''
                    function()
                      -- Try to find .golangci-lint.yaml in common locations
                      local config_paths = {
                        ".golangci-lint.yaml",
                        ".golangci.yaml",
                        ".golangci-lint.yml",
                        ".golangci.yml",
                        "config/.golangci-lint.yaml",
                        "config/.golangci.yaml",
                        "config/.golangci-lint.yml",
                        "config/.golangci.yml",
                        -- Add more custom paths as needed
                      }

                      for _, path in ipairs(config_paths) do
                        local full_path = vim.fn.getcwd() .. "/" .. path
                        if vim.fn.filereadable(full_path) == 1 then
                          return { "--config", full_path }
                        end
                      end

                      return {}
                    end
                  '';
                };
              };
            };
            hadolint.enable = true;
            markdownlint.enable = true;
            staticcheck = {
              enable = true;
              package = null;
            };
            terraform_validate = {
              enable = true;
              package = pkgs.terraform;
            };
            tidy.enable = true;
            todo_comments.enable = true;
            trail_space.enable = true;
            trivy.enable = true;
            yamllint.enable = true;
          };
          formatting = {
            # buf.enable = true;
            gofumpt = {
              enable = true;
              package = null;
            };
            goimports = {
              enable = true;
              package = null;
            };
            markdownlint.enable = true;
            nixfmt.enable = true;
            pg_format.enable = true;
            prettier.enable = false; # due to ts_ls being enabled (lsp)
            shfmt.enable = true;
            terraform_fmt = {
              enable = true;
              package = pkgs.terraform;
            };
            tidy.enable = true;
            yamlfmt.enable = true;
          };
        };
      };
      lualine = {
        enable = true;
        settings = {
          options = {
            disabled_filetypes = {
              __unkeyed-1 = "startify";
              __unkeyed-2 = "neo-tree";
              statusline = [ "dap-repl" ];
            };
            globalstatus = true;
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" ];
            lualine_c = [ "filename" "diff" ];
            lualine_x = [
              "diagnostics"
              {
                __unkeyed-1 = {
                  __raw = ''
                    function()
                        local msg = ""
                        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                        local clients = vim.lsp.get_clients()
                        if next(clients) == nil then
                            return msg
                        end
                        for _, client in ipairs(clients) do
                            local filetypes = client.config.filetypes
                            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                return client.name
                            end
                        end
                        return msg
                    end
                  '';
                };
                color = { fg = "#ffffff"; };
                icon = "";
              }
              "encoding"
              "fileformat"
              "filetype"
            ];
            lualine_y = [{
              __unkeyed-1 = "aerial";
              colored = true;
              cond = {
                __raw = ''
                  function()
                    local buf_size_limit = 1024 * 1024
                    if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
                      return false
                    end

                    return true
                  end
                '';
              };
              dense = false;
              dense_sep = ".";
              depth = { __raw = "nil"; };
              sep = " ) ";
            }];
            lualine_z = [{ __unkeyed-1 = "location"; }];
          };
          tabline = {
            lualine_a = [{
              __unkeyed-1 = "buffers";
              symbols = { alternate_file = ""; };
            }];
            lualine_z = [ "tabs" ];
          };
        };
      };
      neo-tree = {
        enable = true;
        settings = {
          log_level = "info";
          auto_clean_after_session_restore = true;
          close_if_last_window = true;
          default_component_configs = {
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
          event_handlers = {
            file_opened = ''
              function(file_path)
                -- Auto close neo-tree when a file is opened
                require("neo-tree").close_all()
              end
            '';
          };
          filesystem = {
            follow_current_file.enabled = true;
            filtered_items = {
              hide_hidden = false;
              hide_dotfiles = false;
              force_visible_in_empty_folder = true;
              hide_gitignored = false;
            };
          };
          window.position = "left";
        };
      };
      nix.enable = true;
      render-markdown = {
        enable = true;
        settings = {
          latex.enabled = false;
          html.enabled = false;
        };
      };
      smear-cursor.enable = false;
      fzf-lua.enable = true;
      noice = {
        enable = true;
        settings = {
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
          routes = [
            {
              # Filter out treesitter "Index out of bounds" errors
              filter = {
                event = "msg_show";
                any = [
                  { find = "Index out of bounds"; }
                  {
                    find =
                      "Error executing vim.schedule lua callback.*treesitter";
                  }
                  { find = "Error in decoration provider.*treesitter"; }
                ];
              };
              opts = { skip = true; };
            }
            {
              # Filter out deprecated warnings
              filter = {
                event = "msg_show";
                any =
                  [ { find = "is deprecated"; } { find = "vim.deprecated"; } ];
              };
              opts = { skip = true; };
            }
            {
              # Filter out gopls build tag discovery messages
              filter = {
                event = "msg_show";
                find = "^%[gopls%]";
              };
              opts = { skip = true; };
            }
          ];
        };
      };
      notify = {
        enable = true;
        settings.timeout = 2000; # default: 5000
      };
      spectre.enable = false;
      telescope = {
        enable = true;
        extensions = {
          live-grep-args = {
            enable = true;
            settings = {
              auto_quoting = true;
              mappings = {
                i = {
                  "<C-i>" = {
                    __raw = ''
                      require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " })'';
                  };
                  "<C-k>" = {
                    __raw = ''
                      require("telescope-live-grep-args.actions").quote_prompt()'';
                  };
                  "<C-s>" = {
                    __raw = ''require("telescope.actions").to_fuzzy_refine'';
                  };
                };
              };
              theme = "ivy";
            };
          };
        };
        keymaps = {
          "<leader>/" = {
            action = "live_grep_args";
            options = { desc = "Telescope Live Grep Args"; };
          };
          "<leader><leader>" = {
            action = "find_files";
            options = { desc = "Telescope Find Files"; };
          };
          "<leader>b" = {
            action = "buffers";
            options = { desc = "Telescope Buffers"; };
          };
          "gd" = {
            action = "lsp_definitions";
            options = { desc = "Telescope LSP Definitions"; };
          };
        };
        # themes: dropdown, cursor, ivy
        settings = {
          defaults = {
            file_ignore_patterns = [
              ".git/"
              "node_modules/"
              "vendor/"
              ".mypy_cache/"
              "__pycache__/"
            ];
            vimgrep_arguments = [
              "rg"
              "--color=never"
              "--no-heading"
              "--hidden"
              "--with-filename"
              "--line-number"
              "--column"
              "--smart-case"
              "--trim"
            ];
          };
          pickers = {
            colorscheme = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
              enable_preview = true;
            };

            current_buffer_fuzzy_find = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            vim_options = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            find_files = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
              hidden = true;
            };

            buffers = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            live_grep = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            live_grep_args = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            help_tags = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            keymaps = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            diagnostics = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            autocommands = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            commands = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            marks = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            man_pages = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            git_files = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            git_status = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            git_commits = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };

            command_history = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "insert";
            };
          };
        };
      };
      todo-comments.enable = true;
      transparent = {
        enable = true;
        settings = {
          exclude_groups = [ "StatusLine" "CursorLine" ];
          extra_groups = [
            "BufferLineBackground"
            "BufferLineBufferSelected"
            "BufferLineFill"
            "BufferLineIndicatorSelected"
            "BufferLineSeparator"
            "BufferLineTabClose"
            "DiagnosticSignError"
            "DiagnosticSignHint"
            "DiagnosticSignInfo"
            "DiagnosticSignWarn"
            "DiagnosticSignWarn"
            "NeoTreeNormal"
            "NeoTreeNormalNC"
            "NotifyBackground"
            "TelescopeBorder"
            "TroubleCount"
            "TroubleFsCount"
            "TroubleNormal"
            "TroubleNormalNC"
            "all"
          ];
        };
      };
      treesitter = {
        enable = true;
        folding = {
          enable = true;
        };
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
          python
          regex
          terraform
          toml
          vim
          vimdoc
          xml
          yaml
        ];
        settings = {
          auto_install = false;
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-context.enable = false;
      treesitter-textobjects.enable = true;
      trim = {
        enable = false;
        settings = {
          highlight = true;
          trim_on_write = false;
          trim_trailing = false;
          trim_first_line = false;
          trim_last_line = false;
        };
      };
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
          auto_fold = false;
          auto_preview = false;
          auto_refresh = true;
        };
      };
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
      twilight.enable = true;
      vim-css-color.enable = true;
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
              group = "Telescope";
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
            {
              __unkeyed-1 = "<C-g>";
              group = "LLM";
            }
          ];
          win = { border = "single"; };
        };
      };
      zig.enable = true;
    };

    # Manual gopls configuration to use version from PATH
    # instead of nixvim bundling Go binary
    # Lua scripts are in separate files for better maintainability
    extraConfigLua = builtins.readFile ./lua/colorscheme.lua
      + builtins.readFile ./lua/gopls-build-tags.lua
      + builtins.readFile ./lua/markdown.lua;
  };
}
