-- Markdown formatting configuration
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
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
  end,
  desc = 'Configure markdown formatting with proper list indentation'
})

-- Additional autocmds to enforce markdown settings
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.md', '*.markdown' },
  command = 'setlocal textwidth=80 nowrap tabstop=4 shiftwidth=4 expandtab',
  desc = 'Enforce textwidth=80, nowrap, and 4-space tabs on markdown buffer enter'
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = { '*.md', '*.markdown' },
  command = 'setlocal textwidth=80 nowrap tabstop=4 shiftwidth=4 expandtab',
  desc = 'Enforce settings when window displays markdown buffer'
})
