-- Load colorscheme based on ~/.config/appearance file.
local appearance_file = vim.fn.expand("~/.config/appearance")
local appearance = "light"

local function persist_appearance(value)
  vim.fn.mkdir(vim.fn.expand("~/.config"), "p")

  local write_file = io.open(appearance_file, "w")
  if write_file then
    write_file:write(value .. "\n")
    write_file:close()
  end
end

local file = io.open(appearance_file, "r")
if file then
  local content = file:read("*line")
  file:close()

  if content == "dark" or content == "light" then
    appearance = content
  elseif content == "mocha" then
    appearance = "dark"
    persist_appearance(appearance)
  elseif content == "latte" then
    appearance = "light"
    persist_appearance(appearance)
  else
    persist_appearance(appearance)
  end
else
  persist_appearance(appearance)
end

local colorscheme = appearance == "dark" and "carbonfox" or "dayfox"
vim.cmd("colorscheme " .. colorscheme)
