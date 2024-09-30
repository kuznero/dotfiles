-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

--
-- Appearance
--

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

config.enable_tab_bar = true
config.use_fancy_tab_bar = true

--
-- Keys
--

config.keys = {
	-- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({
			key = "b",
			mods = "ALT",
		}),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
}

--
-- Fonts
--
-- https://wezfurlong.org/wezterm/config/lua/wezterm/font.html
-- https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
-- wezterm ls-fonts
-- wezterm ls-fonts --list-system
--
config.font_size = 13.8
config.warn_about_missing_glyphs = true
config.freetype_load_target = "HorizontalLcd" -- https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html

-- Monaspace:  https://monaspace.githubnext.com/
-- Based upon, contributed to:  https://gist.github.com/ErebusBat/9744f25f3735c1e0491f6ef7f3a9ddc3
config.font = wezterm.font({ -- Normal text
	family = "Monaspace Neon",
	harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
	stretch = "UltraCondensed", -- This doesn't seem to do anything
})

config.font_rules = {
	{ -- Italic
		intensity = "Normal",
		italic = true,
		font = wezterm.font({
			-- family="Monaspace Radon",  -- script style
			family = "Monaspace Xenon", -- courier-like
			style = "Italic",
		}),
	},

	{ -- Bold
		intensity = "Bold",
		italic = false,
		font = wezterm.font({
			family = "Monaspace Krypton",
			-- weight='ExtraBold',
			weight = "Bold",
		}),
	},

	{ -- Bold Italic
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			family = "Monaspace Xenon",
			style = "Italic",
			weight = "Bold",
		}),
	},
}

return config
