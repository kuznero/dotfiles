{ inputs, pkgs, ollamaModel ? "qwen2.5-coder:7b", ... }:

# NOTE: after installing nixvim, start it, and run `checkhealth` command to ensure no errors.
# NOTE: sometimes, it might be required to run `TSUpdate` command to clear some of the errors/warnings.

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  home.packages = with pkgs; [ chafa gomodifytags impl ueberzugpp viu ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs; [ gotools gofumpt delve ];

    extraPlugins = with pkgs; [
      vimPlugins.ayu-vim
      vimPlugins.catppuccin-nvim
      vimPlugins.dracula-nvim
      vimPlugins.everforest
      vimPlugins.gruvbox-nvim
      vimPlugins.kanagawa-nvim
      vimPlugins.melange-nvim
      vimPlugins.monokai-pro-nvim
      vimPlugins.monokai-pro-nvim
      vimPlugins.nightfox-nvim
      vimPlugins.onedark-nvim
      vimPlugins.oxocarbon-nvim
      vimPlugins.vscode-nvim
    ];

    autoCmd = [
      {
        event = "FileType";
        pattern = [ "markdown" ];
        command = "setlocal wrap";
        desc = "Enable wrapping on markdown";
      }
      {
        event = "FileType";
        pattern = [ "helm" ];
        command = "LspRestart";
        desc =
          "ref: https://github.com/nix-community/nixvim/issues/989#issuecomment-2333728503";
      }
    ];

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
        key = "<leader>g";
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
    ];

    editorconfig.enable = true;
    colorschemes = { catppuccin.enable = true; };
    colorscheme = "catppuccin-mocha";
    # colorscheme = "carbonfox";

    opts = {
      autoindent = true;
      breakindent = true;
      cursorline = true;
      colorcolumn = "80";
      endofline = false;
      expandtab = true;
      foldenable = false;
      fileformat = "unix";
      fileformats = ["unix" "dos"];
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
      copilot-vim.enable = true;
      codecompanion = {
        enable = true;
        settings = {
          adapters = {
            ollama = {
              __raw = ''
                function()
                  return require('codecompanion.adapters').extend('ollama', {
                    env = {
                      url = "http://127.0.0.1:11434",
                    },
                    schema = {
                      model = {
                        default = '${ollamaModel}',
                        -- default = "llama3.1:8b-instruct-q8_0",
                      },
                      num_ctx = {
                        default = 32768,
                      },
                    },
                  })
                end
              '';
            };
          };
          display = {
            action_palette = {
              opts = { show_default_prompt_library = true; };
              provider = "default";
            };
            chat = {
              window = {
                layout = "vertical";
                opts = { breakindent = true; };
              };
            };
          };
          # prompt_library = {
          #   "Custom Prompt" = {
          #     description = "Prompt the LLM from Neovim";
          #     opts = {
          #       index = 3;
          #       is_default = true;
          #       is_slash_cmd = false;
          #       user_prompt = true;
          #     };
          #     prompts = [{
          #       content = {
          #         __raw = ''
          #           function(context)
          #             return fmt(
          #               [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
          #               context.filetype
          #             )
          #           end
          #         '';
          #       };
          #       opts = {
          #         tag = "system_tag";
          #         visible = false;
          #       };
          #       role = { __raw = "system"; };
          #     }];
          #     strategy = "inline";
          #   };
          #   "Generate a Commit Message" = {
          #     description = "Generate a commit message";
          #     opts = {
          #       auto_submit = true;
          #       index = 10;
          #       is_default = true;
          #       is_slash_cmd = true;
          #       short_name = "commit";
          #     };
          #     prompts = [{
          #       content = {
          #         __raw = ''
          #           function()
          #             return fmt(
          #               [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
          #
          #               ```diff
          #               %s
          #               ```
          #               ]],
          #               vim.fn.system("git diff --no-ext-diff --staged")
          #             )
          #           end
          #         '';
          #       };
          #       opts = { contains_code = true; };
          #       role = "user";
          #     }];
          #     strategy = "chat";
          #   };
          # };
          opts = {
            log_level = "TRACE";
            send_code = true;
            use_default_actions = true;
            use_default_prompts = true;
          };
          strategies = {
            agent = { adapter = "copilot"; };
            chat = { adapter = "copilot"; };
            inline = { adapter = "copilot"; };
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
      gitsigns.enable = true;
      lazygit.enable = true;
      helm.enable = true;
      lint.enable = true;
      lsp = {
        enable = true;
        servers = {
          gopls = {
            enable = true;
            autostart = true;
            # ref: https://github.com/nix-community/nixvim/discussions/1442
            package = pkgs.gopls;
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
          yamlls.enable = true;
          zls.enable = true;
        };
      };
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      mini = { enable = true; };
      mkdnflow = {
        enable = true;
        modules = {
          bib = true;
          buffers = true;
          conceal = true;
          cursor = true;
          folds = true;
          links = true;
          lists = true;
          maps = true;
          paths = true;
          tables = true;
          yaml = false;
        };
        filetypes = {
          md = true;
          rmd = true;
          markdown = true;
        };
        createDirs = true;
        perspective = {
          priority = "first";
          fallback = "first";
          rootTell = false;
          nvimWdHeel = false;
          update = true;
        };
        wrap = false;
        bib = {
          defaultPath = null;
          findInRoot = true;
        };
        silent = false;
        links = {
          style = "markdown";
          conceal = false;
          context = 0;
          implicitExtension = null;
          transformExplicit = false;
          transformImplicit = ''
            function(text)
              text = text:gsub(" ", "-")
              text = text:lower()
              text = os.date('%Y-%m-%d_')..text
              return(text)
            end
          '';
        };
        toDo = {
          symbols = [ " " "-" "X" ];
          updateParents = true;
          notStarted = " ";
          inProgress = "-";
          complete = "X";
        };
        tables = {
          trimWhitespace = true;
          formatOnMove = true;
          autoExtendRows = false;
          autoExtendCols = false;
        };
        yaml = { bib = { override = false; }; };
        mappings = {
          MkdnCreateLink = false;
          MkdnCreateLinkFromClipboard = false;
          MkdnDecreaseHeading = false;
          MkdnDestroyLink = false;
          MkdnEnter = false;
          MkdnExtendList = false;
          MkdnFoldSection = false;
          MkdnFollowLink = false;
          MkdnGoBack = false;
          MkdnGoForward = false;
          MkdnIncreaseHeading = false;
          MkdnMoveSource = false;
          MkdnNewListItem = false;
          MkdnNewListItemAboveInsert = false;
          MkdnNewListItemBelowInsert = false;
          MkdnNextHeading = false;
          MkdnNextLink = false;
          MkdnPrevHeading = false;
          MkdnPrevLink = false;
          MkdnSTab = false;
          MkdnTab = false;
          MkdnTableNewColAfter = false;
          MkdnTableNewColBefore = false;
          MkdnTableNewRowAbove = false;
          MkdnTableNewRowBelow = false;
          MkdnTableNextCell = false;
          MkdnTableNextRow = false;
          MkdnTablePrevCell = false;
          MkdnTablePrevRow = false;
          MkdnToggleToDo = false;
          MkdnUnfoldSection = false;
          MkdnUpdateNumbering = false;
          MkdnYankAnchorLink = false;
          MkdnYankFileAnchorLink = false;
          MkdnTableFormat = {
            key = "<leader>ft";
            modes = "n";
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
            golangci_lint.enable = true;
            hadolint.enable = true;
            markdownlint.enable = true;
            staticcheck.enable = true;
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
            gofumpt.enable = true;
            goimports.enable = true;
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
                        local clients = vim.lsp.get_active_clients()
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
      nix.enable = true;
      render-markdown = {
        enable = true;
        settings = {
          latex.enabled = false;
          html.enabled = false;
        };
      };
      smear-cursor.enable = true;
      fzf-lua.enable = true;
      noice = {
        enable = true;
        settings = {
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
        };
      };
      notify = {
        enable = true;
        settings.timeout = 2000; # default: 5000
      };
      spectre.enable = true;
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
          "gr" = {
            action = "lsp_references";
            options = { desc = "Telescope LSP References"; };
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
        folding = true;
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
          terraform
          toml
          vim
          vimdoc
          xml
          yaml
        ];
        settings = {
          auto_install = true;
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
  };
}
