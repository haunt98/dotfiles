local wezterm = require("wezterm")
local act = wezterm.action

-- Custom fonts config
-- wezterm ls-fonts --list-system
local function font_with_fallback(main_font)
	local fonts = {
		main_font,
		{
			family = "Apple Color Emoji",
			assume_emoji_presentation = true,
		},
		"Symbols Nerd Font Mono",
	}
	return wezterm.font_with_fallback(fonts)
end

-- https://github.com/be5invis/Iosevka
local font_iosevka = {
	font = font_with_fallback({
		family = "Iosevka Pacman",
	}),
	font_size = 16.0,
	line_height = 1.2,
	default_cursor_style = "SteadyBar",
}

local current_font = font_iosevka
local current_color_scheme = "Catppuccin Mocha"

return {
	font = current_font.font,
	font_rules = current_font.font_rules,
	font_size = current_font.font_size,
	line_height = current_font.line_height,
	use_cap_height_to_scale_fallback_fonts = true,

	color_scheme = current_color_scheme,

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

	default_cursor_style = current_font.default_cursor_style,
	audible_bell = "Disabled",

	front_end = "WebGpu",
}
