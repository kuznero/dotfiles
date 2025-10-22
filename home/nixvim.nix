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
      vimPlugins.base16-nvim
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

    autoCmd = [
      {
        event = "FileType";
        pattern = [ "markdown" ];
        callback = {
          __raw = ''
            function()
              vim.opt_local.textwidth = 80
              vim.opt_local.wrap = false

              -- formatoptions controls how automatic formatting is done
              -- t: Auto-wrap text using textwidth
              -- c: Auto-wrap comments using textwidth
              -- q: Allow formatting of comments with "gq"
              -- n: Recognize numbered lists when formatting
              -- 2: When formatting text, use the indent of the second line of a paragraph
              --    for the rest of the paragraph, instead of the indent of the first line.
              vim.opt_local.formatoptions = "tcqn2"

              vim.opt_local.autoindent = true
              vim.opt_local.smartindent = false  -- Disable smartindent as it can interfere

              -- Custom format expression to handle indented paragraphs, lists, and quotes
              -- This function preserves the indentation when formatting with gq
              _G.markdown_format = function()
                -- Safety check - only handle gq and gw operations
                if vim.v.operator ~= 'gq' and vim.v.operator ~= 'gw' then
                  return 0  -- Return 0 for non-formatting operations
                end

                local start_line = vim.v.lnum
                local end_line = start_line + vim.v.count - 1

                -- Get the lines to format
                local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
                if #lines == 0 then return 1 end

                -- Function to format a single block of text
                local function format_block(block_lines, block_indent, block_list_marker, block_quote_prefix)
                  local continuation_indent
                  if block_quote_prefix then
                    -- For quotes, each line should start with the quote prefix
                    if block_list_marker then
                      -- For list items in quotes, indent continuation lines to align with text
                      continuation_indent = block_indent .. block_quote_prefix .. string.rep(" ", #block_list_marker)
                    else
                      -- For regular quotes, just repeat the quote prefix
                      continuation_indent = block_indent .. block_quote_prefix
                    end
                  else
                    -- For non-quotes, indent continuation lines for list items
                    continuation_indent = block_indent .. string.rep(" ", #(block_list_marker or ""))
                  end

                  -- Join all lines into one string
                  local text = ""
                  for i, line in ipairs(block_lines) do
                    local trimmed
                    if block_quote_prefix then
                      -- For quote lines, remove the quote prefix and following spaces
                      local pattern = "^" .. block_indent:gsub(".", "%%%0") .. block_quote_prefix:gsub(".", "%%%0") .. "%s*"
                      trimmed = line:gsub(pattern, "")
                      -- Also handle list markers in quotes
                      if i == 1 and block_list_marker then
                        trimmed = trimmed:match("^[-*+]%s+(.*)$") or trimmed:match("^%d+%.%s+(.*)$") or trimmed
                      end
                    elseif i == 1 and block_list_marker then
                      -- For the first line of a list item, extract text after the marker
                      trimmed = line:match("^%s*[-*+]%s+(.*)$") or line:match("^%s*%d+%.%s+(.*)$") or ""
                    else
                      -- For other lines, remove all leading whitespace
                      trimmed = line:gsub("^%s*", "")
                    end
                    if trimmed ~= "" then
                      if text == "" then
                        text = trimmed
                      else
                        text = text .. " " .. trimmed
                      end
                    end
                  end

                  -- Split text into words
                  local words = {}
                  for word in text:gmatch("%S+") do
                    table.insert(words, word)
                  end

                  -- Rebuild lines with proper width and indentation
                  local formatted_lines = {}
                  local first_line_prefix = block_indent .. (block_quote_prefix or "") .. (block_list_marker or "")
                  local current_line = first_line_prefix
                  local line_length = #current_line

                  for _, word in ipairs(words) do
                    local word_length = #word
                    if line_length + word_length + 1 > vim.o.textwidth and current_line ~= first_line_prefix then
                      -- Start a new line
                      table.insert(formatted_lines, current_line)
                      current_line = continuation_indent .. word
                      line_length = #continuation_indent + word_length
                    else
                      -- Add word to current line
                      if current_line == first_line_prefix then
                        current_line = current_line .. word
                      else
                        current_line = current_line .. " " .. word
                      end
                      line_length = line_length + word_length + 1
                    end
                  end

                  -- Add the last line
                  if current_line ~= first_line_prefix then
                    table.insert(formatted_lines, current_line)
                  end

                  return formatted_lines
                end

                -- Process lines, detecting quotes, list items, and regular paragraphs
                local all_formatted_lines = {}
                local current_block = {}
                local current_indent = nil
                local current_list_marker = nil
                local current_quote_prefix = nil

                for i, line in ipairs(lines) do
                  local line_indent = line:match("^(%s*)") or ""

                  -- Check if this line is a quote (starts with > after optional whitespace)
                  local quote_match = line:match("^" .. line_indent:gsub(".", "%%%0") .. "(>+%s*)")

                  -- Check if this line starts a new list item (after potential quote prefix)
                  local check_line = line
                  if quote_match then
                    check_line = line:sub(#line_indent + #quote_match + 1)
                  end

                  local _, _, line_list_marker
                  if quote_match then
                    -- For quotes, check for list markers after the quote prefix
                    _, _, line_list_marker = check_line:find("^([-*+]%s)")
                    if not line_list_marker then
                      _, _, line_list_marker = check_line:find("^(%d+%.%s)")
                    end
                  else
                    -- Regular list item check
                    _, _, line_list_marker = line:find("^" .. line_indent:gsub(".", "%%%0") .. "([-*+]%s)")
                    if not line_list_marker then
                      _, _, line_list_marker = line:find("^" .. line_indent:gsub(".", "%%%0") .. "(%d+%.%s)")
                    end
                  end

                  -- Determine if we need to start a new block
                  local needs_new_block = false

                  if i == 1 then
                    -- First line always starts a new block
                    needs_new_block = true
                  elseif quote_match ~= current_quote_prefix then
                    -- Quote prefix changed
                    needs_new_block = true
                  elseif line_list_marker and #current_block > 0 then
                    -- New list item starts
                    needs_new_block = true
                  elseif not quote_match and not line_list_marker and
                         current_quote_prefix and #line:gsub("^%s*", "") > 0 then
                    -- Non-quote line after a quote block
                    needs_new_block = true
                  end

                  -- If we need a new block and have a current block, format it
                  if needs_new_block and #current_block > 0 then
                    local formatted = format_block(current_block, current_indent, current_list_marker, current_quote_prefix)
                    for _, formatted_line in ipairs(formatted) do
                      table.insert(all_formatted_lines, formatted_line)
                    end
                    current_block = {}
                  end

                  -- Start or continue current block
                  if needs_new_block then
                    current_indent = line_indent
                    current_list_marker = line_list_marker
                    current_quote_prefix = quote_match
                  end

                  table.insert(current_block, line)
                end

                -- Format the last block
                if #current_block > 0 then
                  local formatted = format_block(current_block, current_indent, current_list_marker, current_quote_prefix)
                  for _, formatted_line in ipairs(formatted) do
                    table.insert(all_formatted_lines, formatted_line)
                  end
                end

                -- Replace the original lines
                vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, all_formatted_lines)

                return 0  -- Return 0 to indicate we handled the formatting
              end

              -- Set the custom format expression
              vim.opt_local.formatexpr = "v:lua.markdown_format()"

              -- formatlistpat defines the pattern that identifies a list item
              -- This pattern matches lines starting with optional whitespace followed by
              -- a dash, asterisk, or plus sign, then at least one space
              vim.opt_local.formatlistpat = "^\\s*[-*+]\\s\\+"

              -- comments defines comment/list markers for automatic formatting
              -- b: means blank required after the marker
              -- Each marker (-, *, +) is recognized for proper list formatting
              vim.opt_local.comments = "b:- ,b:* ,b:+ "

              -- How it works:
              -- For list items:
              -- 1. When you select a list item and press 'gq'
              -- 2. Vim checks if the line matches formatlistpat (is it a list item?)
              -- 3. If yes, and formatoptions contains '2', Vim formats the text
              -- 4. The continuation lines are indented to align with the text after the marker
              --
              -- For indented paragraphs:
              -- 1. When you select an indented paragraph and press 'gq'
              -- 2. With the '2' flag, Vim preserves the indentation of the paragraph
              -- 3. All wrapped lines maintain the same indentation as the original
              --
              -- Examples:
              -- List item before gq:
              -- - This is a very long line that needs to be wrapped because it exceeds textwidth
              --
              -- After gq:
              -- - This is a very long line that needs to be wrapped because it exceeds
              --   textwidth
              --
              -- Indented paragraph before gq:
              --     This is an indented paragraph with a very long line that needs to be wrapped because it exceeds the configured textwidth of 80 characters
              --
              -- After gq:
              --     This is an indented paragraph with a very long line that needs to be
              --     wrapped because it exceeds the configured textwidth of 80 characters
            end
          '';
        };
        desc = "Configure markdown formatting with proper list indentation";
      }
      {
        event = "BufEnter";
        pattern = [ "*.md" "*.markdown" ];
        command =
          "setlocal textwidth=80 nowrap tabstop=4 shiftwidth=4 expandtab";
        desc =
          "Enforce textwidth=80, nowrap, and 4-space tabs on markdown buffer enter";
      }
      {
        event = "BufWinEnter";
        pattern = [ "*.md" "*.markdown" ];
        command =
          "setlocal textwidth=80 nowrap tabstop=4 shiftwidth=4 expandtab";
        desc = "Enforce settings when window displays markdown buffer";
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
    ];

    editorconfig.enable = true;
    colorschemes = { catppuccin.enable = true; };
    colorscheme = "catppuccin-latte";
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
            golangci_lint = {
              enable = true;
              package = null;
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
      smear-cursor.enable = true;
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
          ];
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
    extraConfigLua = ''
      -- Configure gopls manually to use from PATH (project devShell)
      -- Using new nvim 0.11+ API instead of deprecated lspconfig
      vim.lsp.config.gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
        settings = {
          gopls = {
            buildFlags = { "-tags=unit,integration" },
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      }

      -- Enable gopls for Go files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'go', 'gomod', 'gowork', 'gotmpl' },
        callback = function(args)
          vim.lsp.enable('gopls')
        end,
      })
    '';
  };
}
