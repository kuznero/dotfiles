{ inputs, config, pkgs, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs; [ gotools gofumpt delve ];

    autoCmd = [{
      event = "FileType";
      pattern = [ "markdown" ];
      command = "setlocal wrap";
      desc = "Enable wrapping on markdown";
    }];

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "gp";
        src = pkgs.fetchFromGitHub {
          owner = "Robitx";
          repo = "gp.nvim";
          rev = "2372d5323c6feaa2e9c19f7ccb537c615d878e18";
          hash = "sha256-QUZrFU/+TPBEU8yi9gmyRYjI/u7DP88AxcS0RMk7Jvk=";
        };
      })
    ];

    extraConfigLua = ''
      require("gp").setup({
        -- openai_api_key = os.getenv("OPENAI_API_KEY"),
        providers = {
          -- anthropic = {
          --   endpoint = "https://api.anthropic.com/v1/messages",
          --   secret = os.getenv("ANTHROPIC_API_KEY"),
          -- },
          -- copilot = {
          --   endpoint = "https://api.githubcopilot.com/chat/completions",
          --   secret = {
          --     "bash",
          --     "-c",
          --     "cat /home/${config.home.username}/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
          --   },
          -- },
          ollama = {
            endpoint = "http://localhost:11434/v1/chat/completions",
          },
          -- openai = {
          --   endpoint = "https://api.openai.com/v1/chat/completions",
          --   secret = vim.fn.getenv("OPENAI_API_KEY"),
          -- },
        },
        default_command_agent = "Qwen2.5Coder",
        default_chat_agent = "Qwen2.5Coder",
        agents = {
          -- {
          --   name = "Codellama",
          --   chat = true,
          --   command = true,
          --   provider = "ollama",
          --   model = { model = "codellama" },
          --   system_prompt = "I am an AI meticulously crafted to provide programming guidance and code assistance. "
          --     .. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
          --     .. "and expect precise, technical responses tailored to your development needs.\n",
          -- },
          {
            name = "Qwen2.5Coder",
            chat = true,
            command = true,
            provider = "ollama",
            model = { model = "qwen2.5-coder:1.5b" },
            system_prompt = "You are a general AI assistant.\n\n"
              .. "The user provided the additional info about how they would like you to respond:\n\n"
              .. "- If you're unsure don't guess and say you don't know instead.\n"
              .. "- Ask question if you need clarification to provide better answer.\n"
              .. "- Think deeply and carefully from first principles step by step.\n"
              .. "- Zoom out first to see the big picture and then zoom in to details.\n"
              .. "- Use Socratic method to improve your thinking and coding skills.\n"
              .. "- Don't elide any code from your output if the answer requires coding.\n"
              .. "- Take a deep breath; You've got this!\n",
          },
        },
        hooks = {
          CodeReview = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please analyze for code smells and suggest improvements."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
          end,
          BufferChatNew = function(gp, _)
            vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
          end,
        },
      })
    '';

    globals = {
      mapleader = "\\";
      maplocalleader = "\\";
    };

    keymaps = [
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

      # gp.nvim keymaps (normal mode)
      {
        mode = "n";
        key = "<C-g><C-t>";
        action = "<cmd>GpChatNew tabnew<CR>";
        options = { desc = "New Chat tabnew"; };
      }
      {
        mode = "n";
        key = "<C-g><C-v>";
        action = "<cmd>GpChatNew vsplit<cr>";
        options = { desc = "New Chat vsplit"; };
      }
      {
        mode = "n";
        key = "<C-g><C-x>";
        action = "<cmd>GpChatNew split<cr>";
        options = { desc = "New Chat split"; };
      }
      {
        mode = "n";
        key = "<C-g>a";
        action = "<cmd>GpAppend<cr>";
        options = { desc = "Append (after)"; };
      }
      {
        mode = "n";
        key = "<C-g>b";
        action = "<cmd>GpPrepend<cr>";
        options = { desc = "Prepend (before)"; };
      }
      {
        mode = "n";
        key = "<C-g>c";
        action = "<cmd>GpChatNew<cr>";
        options = { desc = "New Chat"; };
      }
      {
        mode = "n";
        key = "<C-g>f";
        action = "<cmd>GpChatFinder<cr>";
        options = { desc = "Chat Finder"; };
      }
      #     ["<C-g>g"] = { name = "generate into new .." },
      {
        mode = "n";
        key = "<C-g>ge";
        action = "<cmd>GpEnew<cr>";
        options = { desc = "GpEnew"; };
      }
      {
        mode = "n";
        key = "<C-g>gn";
        action = "<cmd>GpNew<cr>";
        options = { desc = "GpNew"; };
      }
      {
        mode = "n";
        key = "<C-g>gp";
        action = "<cmd>GpPopup<cr>";
        options = { desc = "Popup"; };
      }
      {
        mode = "n";
        key = "<C-g>gt";
        action = "<cmd>GpTabnew<cr>";
        options = { desc = "GpTabnew"; };
      }
      {
        mode = "n";
        key = "<C-g>gv";
        action = "<cmd>GpVnew<cr>";
        options = { desc = "GpVnew"; };
      }
      {
        mode = "n";
        key = "<C-g>n";
        action = "<cmd>GpNextAgent<cr>";
        options = { desc = "Next Agent"; };
      }
      {
        mode = "n";
        key = "<C-g>r";
        action = "<cmd>GpRewrite<cr>";
        options = { desc = "Inline Rewrite"; };
      }
      {
        mode = "n";
        key = "<C-g>s";
        action = "<cmd>GpStop<cr>";
        options = { desc = "GpStop"; };
      }
      {
        mode = "n";
        key = "<C-g>t";
        action = "<cmd>GpChatToggle<cr>";
        options = { desc = "Toggle Chat"; };
      }
      {
        mode = "n";
        key = "<C-g>x";
        action = "<cmd>GpContext<cr>";
        options = { desc = "Toggle GpContext"; };
      }
    ];

    editorconfig.enable = true;
    colorschemes = {
      # ayu.enable = true;
      # base16.enable = true;
      catppuccin.enable = true;
      # cyberdream.enable = true;
      # dracula-nvim.enable = true;
      # everforest.enable = true;
      # gruvbox.enable = true;
      # kanagawa.enable = true;
      # melange.enable = true;
      # modus.enable = true;
      # nightfox.enable = true;
      # nord.enable = true;
      # one.enable = true;
      # onedark.enable = true;
      # oxocarbon.enable = true;
      # palette.enable = true;
      # poimandres.enable = true;
      # rose-pine.enable = true;
      # tokyonight.enable = true;
      # vscode.enable = true;
    };

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
      aerial.enable = true;
      # airline.enable = true;
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
      # bufferline.enable = true;
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
        extensions = {
          dap-go = {
            enable = true;
            delve.path = "${pkgs.delve}/bin/dlv";
          };
          dap-ui = { enable = true; };
          dap-virtual-text = { enable = true; };
        };
      };
      comment.enable = true;
      coverage.enable = true;
      dressing.enable = true;
      flash.enable = true;
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
        };
      };
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
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
            ts_node_action.enable = true;
          };
          diagnostics = {
            buf.enable = true;
            golangci_lint.enable = true;
            hadolint.enable = true;
            markdownlint.enable = true;
            staticcheck.enable = true;
            terraform_validate.enable = true;
            tfsec.enable = true;
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
            nixpkgs_fmt.enable = true;
            pg_format.enable = true;
            prettier.enable = false; # due to ts_ls being enabled (lsp)
            shfmt.enable = true;
            terraform_fmt.enable = true;
            tidy.enable = true;
            yamlfmt.enable = true;
          };
        };
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
      notify = {
        enable = true;
        timeout = 2000; # default: 5000
      };
      nvim-lightbulb.enable = true;
      persistence.enable = true;
      spectre.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>/" = {
            action = "live_grep";
            options = { desc = "Telescope Live Grep"; };
          };
          "<leader><leader>" = {
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
        settings = {
          pickers = {
            colorscheme = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
              enable_preview = true;
            };

            current_buffer_fuzzy_find = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            vim_options = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            find_files = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            buffers = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            live_grep = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            help_tags = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            keymaps = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            diagnostics = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            autocommands = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            commands = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            marks = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            man_pages = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            git_files = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            git_status = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            git_commits = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };

            command_history = {
              theme = "ivy";
              sort_mru = true;
              sort_lastused = true;
              initial_mode = "normal";
            };
          };
        };
      };
      todo-comments.enable = true;
      transparent.enable = true;
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
          auto_open = true;
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
    };
  };
}
