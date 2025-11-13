-- Cache for build tags per project root
local build_tag_cache = {}
-- Track ongoing discoveries to prevent duplicates
local discovery_in_progress = {}

-- Logging helper function
-- Always logs to :messages, optionally shows noice notification
local function log(msg, notify)
  print(msg)  -- Log to :messages (filtered by noice)
  if notify then
    vim.notify(msg, vim.log.levels.INFO)  -- Show as noice notification
  end
end

-- Get the Go project root
-- Simply returns cwd - we search for build tags across all Go files under cwd
local function find_go_root()
  local cwd = vim.fn.getcwd()

  -- Verify there are actually Go files in this directory tree
  local check_cmd = string.format(
    "find %s -maxdepth 6 -type f -name '*.go' -print -quit 2>/dev/null",
    vim.fn.shellescape(cwd)
  )

  local handle = io.popen(check_cmd)
  if handle then
    local result = handle:read("*l")
    handle:close()
    if result and result ~= "" then
      return cwd
    end
  end

  return nil
end

-- Check if directory is in a git repository
-- Only checks cwd, never searches parent directories
-- Handles both normal clones (.git directory) and worktrees (.git file)
local function is_git_repo(dir)
  local git_path = dir .. '/.git'
  return vim.fn.isdirectory(git_path) == 1 or vim.fn.filereadable(git_path) == 1
end

-- Update gopls build flags dynamically
local function update_gopls_buildflags(tags_arg)
  -- Find the gopls client
  local clients = vim.lsp.get_clients({ name = 'gopls' })

  for _, client in ipairs(clients) do
    if client.name == 'gopls' then
      client.config.settings.gopls.buildFlags = tags_arg and { tags_arg } or {}
      client.notify('workspace/didChangeConfiguration', {
        settings = client.config.settings
      })
      log("[gopls] Build flags updated", false)
      break
    end
  end
end

-- Async function to discover build tags using ripgrep
local function discover_build_tags_async(opts)
  opts = opts or {}
  local force = opts.force or false  -- Skip git check if force=true

  local root_dir = find_go_root()

  -- Early exit: not in Go project
  if not root_dir then
    if force then
      log("[gopls] Not in a Go project", true)  -- Show notification
    end
    return
  end

  log("[gopls] Go project root: " .. root_dir, false)

  -- Early exit: not in git repo (unless forced)
  if not force and not is_git_repo(root_dir) then
    log("[gopls] Skipping build tag discovery: not in a git repository. Use :GoplsDiscoverTags to force.", true)  -- Show notification
    return
  end

  -- Prevent duplicate discoveries unless forced
  if not force and discovery_in_progress[root_dir] then
    log("[gopls] Discovery already in progress for " .. vim.fn.fnamemodify(root_dir, ':t'), false)
    return
  end

  log("[gopls] Starting build tag discovery...", false)

  -- Check cache
  if build_tag_cache[root_dir] ~= nil then
    local cache_msg = "[gopls] Using cached build tags for " .. vim.fn.fnamemodify(root_dir, ':t')
    if build_tag_cache[root_dir] then
      cache_msg = cache_msg .. ": " .. build_tag_cache[root_dir]
    else
      cache_msg = cache_msg .. ": (none)"
    end
    log(cache_msg, false)
    if opts.update_gopls then
      update_gopls_buildflags(build_tag_cache[root_dir])
    end
    return build_tag_cache[root_dir]
  end

  -- Prefer ripgrep, fallback to grep
  -- For git repos: no restrictions (search all files)
  -- For non-git repos: apply safety limits (maxdepth, max-count)
  local is_git = is_git_repo(root_dir)
  local cmd
  local cmd_name

  if vim.fn.executable('rg') == 1 then
    cmd_name = "ripgrep"
    cmd = {
      'rg',
      '--type', 'go',
      '--no-heading',
      '--no-filename',
      '--no-messages',  -- Suppress permission denied errors
    }

    -- Only limit search for non-git repos
    if not is_git then
      table.insert(cmd, '--max-count')
      table.insert(cmd, '100')
    end

    table.insert(cmd, '^//(go:build|\\s*\\+build)')
    table.insert(cmd, root_dir)
  else
    cmd_name = "find+grep"
    local find_opts

    -- Only limit search for non-git repos
    if not is_git then
      find_opts = "-maxdepth 6 -type f -name '*.go' 2>/dev/null | head -500"
    else
      find_opts = "-type f -name '*.go' 2>/dev/null"
    end

    cmd = {
      'sh', '-c',
      string.format(
        "find %s %s | xargs grep -h '^//go:build\\|^// +build' 2>/dev/null | sort -u",
        vim.fn.shellescape(root_dir),
        find_opts
      )
    }
  end

  log("[gopls] Using " .. cmd_name .. " to search for build tags", false)

  -- Mark discovery as in progress
  discovery_in_progress[root_dir] = true

  -- Run async using vim.system (nvim 0.10+)
  vim.system(cmd, { text = true }, function(result)
    vim.schedule(function()
      -- Clear in-progress flag
      discovery_in_progress[root_dir] = nil

      log("[gopls] Search completed with exit code: " .. result.code, false)

      if result.code ~= 0 then
        -- No tags found or error
        if result.stderr and #result.stderr > 0 then
          log("[gopls] Error output: " .. result.stderr, false)
        end
        build_tag_cache[root_dir] = nil
        log("[gopls] No build tags discovered", true)  -- Show notification
        if opts.update_gopls then
          update_gopls_buildflags(nil)
        end
        return
      end

      local tags = {}
      local line_count = 0
      for line in result.stdout:gmatch("[^\r\n]+") do
        line_count = line_count + 1
        -- Extract tags from //go:build and // +build directives
        for tag in line:gmatch("([%w_]+)") do
          if tag ~= "go" and tag ~= "build" and tag ~= "ignore" then
            tags[tag] = true
          end
        end
      end

      log("[gopls] Processed " .. line_count .. " lines", false)

      local tag_list = {}
      for tag, _ in pairs(tags) do
        table.insert(tag_list, tag)
      end

      if #tag_list > 0 then
        table.sort(tag_list)
        local tags_str = table.concat(tag_list, ",")
        local tags_arg = "-tags=" .. tags_str

        -- Cache result
        build_tag_cache[root_dir] = tags_arg

        log("[gopls] Discovered build tags: " .. tags_str, true)  -- Show notification

        if opts.update_gopls then
          update_gopls_buildflags(tags_arg)
        end

        return tags_arg
      else
        build_tag_cache[root_dir] = nil
        log("[gopls] No build tags discovered (no tags extracted)", true)  -- Show notification
        if opts.update_gopls then
          update_gopls_buildflags(nil)
        end
      end
    end)
  end)
end

-- Configure gopls manually to use from PATH (project devShell)
-- Using new nvim 0.11+ API instead of deprecated lspconfig
vim.lsp.config.gopls = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    gopls = {
      buildFlags = {},  -- Start empty, will be populated async
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

-- Discover build tags async when gopls attaches (with git check)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'gopls' then
      -- Discover tags async, only if in git repo
      discover_build_tags_async({ update_gopls = true, force = false })
    end
  end,
})

-- Command to manually trigger build tag discovery (bypasses git check)
vim.api.nvim_create_user_command('GoplsDiscoverTags', function()
  -- Clear cache and in-progress flag for current project
  local root_dir = find_go_root()
  if root_dir then
    build_tag_cache[root_dir] = nil
    discovery_in_progress[root_dir] = nil
  end
  discover_build_tags_async({ update_gopls = true, force = true })
end, { desc = 'Manually discover Go build tags and update gopls' })
