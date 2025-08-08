local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "wezterm"
config.color_scheme = "Everblush"

config.kde_window_background_blur = true
config.macos_window_background_blur = 20

-- background
config.background = {
	{
		source = { Color = "black" },
		width = "100%",
		height = "100%",
		opacity = 0.4,
	},
}

-- font
config.font = wezterm.font_with_fallback({
	{
		family = "BitstromWera Nerd Font Mono",
		weight = 400,
		harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
	},
})
config.font_size = 12.5

-- window
config.window_decorations = "None"
config.adjust_window_size_when_changing_font_size = false
config.initial_cols = 180
config.initial_rows = 50

-- mouse bindings
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
