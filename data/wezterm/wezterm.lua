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
		family = "Iosevka Term",
		harfbuzz_features = {
			"ss08=1",
			"calt=0",
			"CLIK=1",
			"cv85=13",
			"VSAF=3",
		},
	}),
	font_size = 16.0,
	line_height = 1.2,
	default_cursor_style = "SteadyBar",
}

-- https://github.com/jenskutilek/sudo-font
local font_sudo = {
	font = font_with_fallback({
		family = "Sudo Var",
		harfbuzz_features = { "cv06" },
	}),
	font_size = 18.0,
	line_height = 1.4,
	default_cursor_style = "SteadyBar",
}

-- https://github.com/pcaro90/hermit
local font_hermit = {
	font = font_with_fallback({
		family = "Hermit",
	}),
	font_size = 14.0,
	line_height = 1.2,
	default_cursor_style = "SteadyBar",
}

local font_ibm = {
	font = font_with_fallback({
		family = "IBM Plex Mono",
	}),
	font_size = 14.0,
	line_height = 1.2,
	default_cursor_style = "SteadyBar",
}

-- https://int10h.org/blog/2018/05/flexi-ibm-vga-scalable-truetype-font/
local font_flexi_ibm = {
	font = font_with_fallback({
		family = "Flexi IBM VGA False",
	}),
	font_rules = {
		{
			intensity = "Bold",
			italic = true,
			font = font_with_fallback({
				family = "Flexi IBM VGA False",
			}),
		},
		{
			intensity = "Bold",
			font = font_with_fallback({
				family = "Flexi IBM VGA False",
			}),
		},
		{
			intensity = "Normal",
			italic = true,
			font = font_with_fallback({
				family = "Flexi IBM VGA False",
			}),
		},
	},
	font_size = 16.0,
	line_height = 1.2,
	default_cursor_style = "SteadyBlock",
}

-- http://www.kreativekorp.com/software/fonts/fairfaxhd/
local font_fairfax = {
	font = font_with_fallback({
		family = "Fairfax Hax HD",
		weight = "Medium",
	}),
	font_rules = {
		{
			intensity = "Bold",
			italic = true,
			font = font_with_fallback({
				family = "Fairfax Hax HD",
				weight = "Medium",
			}),
		},
		{
			intensity = "Bold",
			font = font_with_fallback({
				family = "Fairfax Hax HD",
				weight = "Medium",
			}),
		},
		{
			intensity = "Normal",
			italic = true,
			font = font_with_fallback({
				family = "Fairfax Hax HD",
				weight = "Medium",
			}),
		},
	},
	font_size = 16.0,
	line_height = 1.4,
	default_cursor_style = "SteadyBlock",
}

-- https://github.com/subframe7536/maple-font
local font_maple = {
	font = font_with_fallback({
		family = "Maple Mono",
		harfbuzz_features = { "cv03", "zero" },
	}),
	font_size = 14.0,
	line_height = 1.2,
	default_cursor_style = "SteadyBar",
}

-- https://github.com/0xType/0xProto
local font_0xproto = {
	font = font_with_fallback({
		family = "0xProto",
	}),
	font_rules = {
		{
			intensity = "Bold",
			italic = true,
			font = font_with_fallback({
				family = "0xProto",
				weight = "Regular",
				italic = true,
			}),
		},
		{
			intensity = "Bold",
			font = font_with_fallback({
				family = "0xProto",
				weight = "Regular",
			}),
		},
		{
			intensity = "Normal",
			italic = true,
			font = font_with_fallback({
				family = "0xProto",
				weight = "Regular",
				italic = true,
			}),
		},
	},
	font_size = 14.0,
	line_height = 1.4,
	default_cursor_style = "SteadyBar",
}

-- https://berkeleygraphics.com/typefaces/berkeley-mono/
local font_berkeley = {
	font = font_with_fallback({
		family = "Berkeley Mono",
		harfbuzz_features = { "ss02" },
	}),
	font_size = 14.0,
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
