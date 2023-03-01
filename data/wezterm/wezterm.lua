local wezterm = require("wezterm")
return {
	font = wezterm.font_with_fallback({
		{
			family = "mononoki",
			harfbuzz_features = { "ss01" },
		},
		"JetBrains Mono",
	}),
	font_size = 16.0,
	color_scheme = "Catppuccin Mocha",
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	window_background_opacity = 0.9,
}
