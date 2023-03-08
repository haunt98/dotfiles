local wezterm = require("wezterm")
return {
	font = wezterm.font_with_fallback({
		{
			family = "mononoki",
			harfbuzz_features = { "ss01" },
		},
		"JetBrains Mono",
		{
			family = "Fira Code",
			harfbuzz_features = { "cv06", "zero", "cv14", "ss04", "cv18", "ss03", "cv16", "cv31" },
		},
	}),
	font_size = 16.0,
	line_height = 1.2,
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
	audible_bell = "Disabled",
}
