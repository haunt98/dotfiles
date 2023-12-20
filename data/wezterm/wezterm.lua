local wezterm = require("wezterm")
local act = wezterm.action

-- Custom fonts config
local flexi_ibm = {
	font = wezterm.font({
		family = "Flexi IBM VGA False",
	}),
	font_rules = {
		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font({
				family = "Flexi IBM VGA False",
			}),
		},
		{
			intensity = "Bold",
			italic = false,
			font = wezterm.font({
				family = "Flexi IBM VGA False",
			}),
		},
		{
			intensity = "Normal",
			italic = true,
			font = wezterm.font({
				family = "Flexi IBM VGA False",
			}),
		},
	},
	font_size = 18.0,
	line_height = 1.2,
	default_cursor_style = "SteadyBlock",
}

return {
	font = flexi_ibm.font,
	font_rules = flexi_ibm.font_rules,
	font_size = flexi_ibm.font_size,
	line_height = flexi_ibm.line_height,
	use_cap_height_to_scale_fallback_fonts = true,

	color_scheme = "Catppuccin Mocha",

	keys = {
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = act.ActivateTabRelative(-1),
		},
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = act.ActivateTabRelative(1),
		},
		-- Sync with Zellij
		{
			key = "n",
			mods = "ALT",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "m",
			mods = "ALT",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "p",
			mods = "ALT",
			action = act.ActivatePaneDirection("Next"),
		},
		{
			key = "o",
			mods = "ALT",
			action = act.SpawnCommandInNewTab({}),
		},
		{
			key = "[",
			mods = "ALT",
			action = act.ActivateTabRelative(-1),
		},
		{
			key = "]",
			mods = "ALT",
			action = act.ActivateTabRelative(1),
		},
	},

	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	tab_and_split_indices_are_zero_based = true,
	tab_max_width = 24,

	native_macos_fullscreen_mode = true,

	default_cursor_style = flexi_ibm.default_cursor_style,
	audible_bell = "Disabled",

	-- Remove in next version
	front_end = "WebGpu",
}
