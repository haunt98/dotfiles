local wezterm = require("wezterm")
local act = wezterm.action

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

return {
	font = wezterm.font({
		family = "SF Mono",
	}),
	font_size = 14.0,
	line_height = 1.2,
	use_cap_height_to_scale_fallback_fonts = true,

	color_scheme = scheme_for_appearance(get_appearance()),

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
			action = act.PaneSelect({
				alphabet = "1234567890",
			}),
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
	tab_max_width = 32,

	window_background_opacity = 0.9,
	text_background_opacity = 0.8,
	macos_window_background_blur = 15,

	default_cursor_style = "SteadyBar",
	audible_bell = "Disabled",
}
