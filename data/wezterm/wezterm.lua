local wezterm = require("wezterm")
return {
	font = wezterm.font({
		family = "SF Mono",
	}),
	font_size = 16.0,
	line_height = 1.2,
	use_cap_height_to_scale_fallback_fonts = true,
	color_scheme = "Catppuccin Mocha",
	keys = {
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivateTabRelative(1),
		},
	},
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	window_background_opacity = 0.9,
	text_background_opacity = 0.8,
	macos_window_background_blur = 20,
	audible_bell = "Disabled",
}
