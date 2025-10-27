-- Load colorscheme based on ~/.config/appearance file
local appearance_file = vim.fn.expand("~/.config/appearance")
local flavor = "latte"  -- default

local file = io.open(appearance_file, "r")
if file then
  local content = file:read("*line")
  file:close()

  if content == "mocha" or content == "latte" then
    flavor = content
  end
else
  -- File doesn't exist, create it with default
  vim.fn.mkdir(vim.fn.expand("~/.config"), "p")
  local write_file = io.open(appearance_file, "w")
  if write_file then
    write_file:write("latte\n")
    write_file:close()
  end
end

vim.cmd("colorscheme catppuccin-" .. flavor)
