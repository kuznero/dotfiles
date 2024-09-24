-- Pull in the wezterm API
local wezterm = require("wezterm")

local function scheme_for_appearance(appearance)
	-- Mocha, Macchiato, Frappe, Latte
	if appearance:find("Dark") then
		return "Catppuccin Macchiato"
	else
		return "Catppuccin Latte"
	end
end

local config = wezterm.config_builder()
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.font = wezterm.font("Monaspace Neon", { weight = "Regular", italic = false })
config.font_size = 12.0

config.enable_tab_bar = true
config.use_fancy_tab_bar = true

return config
