local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.term = "wezterm"
config.color_scheme = "Everblush"

config.kde_window_background_blur = true
config.macos_window_background_blur = 20
config.enable_tab_bar = false

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

-- key bindings
local k = require("utils.keys")

config.keys = {
  -- panes
  k.cmd_to_tmux("d", "%"),
  k.cmd_to_tmux("D", "\""),
  k.cmd_to_tmux("w", "x"),

  -- move in panes
  k.cmd_to_tmux("h", "LeftArrow"),
  k.cmd_to_tmux("l", "RightArrow"),
  k.cmd_to_tmux("j", "DownArrow"),
  k.cmd_to_tmux("k", "UpArrow"),

  -- tab management
  k.cmd_to_tmux("t", "c"),

  -- cycle tabs
  k.cmd_to_tmux("p", "p"),
  k.cmd_to_tmux("n", "n"),

  -- tab quick select
  k.cmd_to_tmux("0", "0"),
  k.cmd_to_tmux("1", "1"),
  k.cmd_to_tmux("2", "2"),
  k.cmd_to_tmux("3", "3"),
  k.cmd_to_tmux("4", "4"),
  k.cmd_to_tmux("5", "5"),
  k.cmd_to_tmux("6", "6"),
  k.cmd_to_tmux("7", "7"),
  k.cmd_to_tmux("8", "8"),
  k.cmd_to_tmux("9", "9"),

  -- cycle Windows
  k.cmd_to_tmux("P", "P"),
  k.cmd_to_tmux("N", "N"),

}

config.default_prog = { "tmux", "-u" }

return config
