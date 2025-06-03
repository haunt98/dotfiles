local wezterm = require("wezterm")
local act = wezterm.action

-- Custom fonts config
-- wezterm ls-fonts --list-system
local function font_with_fallback(main_font)
	local fonts = {
		main_font,
		"Symbols Nerd Font Mono",
	}
	return wezterm.font_with_fallback(fonts)
end

-- https://github.com/coz-m/MPLUS_FONTS
local font_mplus = {
	font = font_with_fallback({
		family = "M PLUS Code Latin 60",
		weight = "Medium",
	}),
	font_size = 14.0,
	line_height = 1.2,
	default_cursor_style = "SteadyBar",
}

local current_font = font_mplus
local current_color_scheme = "Catppuccin Mocha"

return {
	font = current_font.font,
	font_rules = current_font.font_rules,
	font_size = current_font.font_size,
	line_height = current_font.line_height,
	use_cap_height_to_scale_fallback_fonts = true,

	color_scheme = current_color_scheme,

	window_padding = {
		left = 16,
		right = 16,
		top = 16,
		bottom = 16,
	},

	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	tab_and_split_indices_are_zero_based = true,
	tab_max_width = 24,

	window_background_opacity = 0.95,

	native_macos_fullscreen_mode = true,

	default_cursor_style = current_font.default_cursor_style,
	audible_bell = "Disabled",

	front_end = "WebGpu",
	max_fps = 120,

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
		-- Inspire from Zellij
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
}
