local wezterm = require("wezterm")

---------------------------------------------------------------
--- Config
---------------------------------------------------------------
local config = {
	-- font = wezterm.font("Cica"),
	-- font_size = 10.0,
	font = wezterm.font("JetBrains Mono Nerd Font", { weight = 600 }),

 --font = wezterm.font("Fira Code", { weight =  600 }),
	-- font = wezterm.font("Fira Code"),
	font_size = 12,
	-- cell_width = 1.1,
	-- line_height = 1.1,
	-- font_rules = {
	--   {
	--     italic = true,
	--     font = wezterm.font("Cica", { weight = 600, italic = true }),
	--   },
	-- 	{
	-- 		italic = true,
	-- 		intensity = "Bold",
	-- 		font = wezterm.font("Cica", { weight = "Bold", italic = true }),
	-- 	},
	-- },
	-- config.title_bar_color = "#14151e"
	-- config.text_background_opacity = 0.2
	window_background_opacity = 0.2,
	-- config.window_padding = 3
	-- config.window_margin_width = 0
	color_scheme = "Tokyo Night Moon",
	-- color_scheme = "Ayu Mirage",

	hide_mouse_cursor_when_typing = true,
	colors = {
		foreground = "#98b0d3",
		background = "#14151e",
		-- cursor_bg = "#cbced3",
		-- cursor_border = "#a5b6cf",
		-- selection_bg = "#1c1e27",
		-- selection_fg = "#a5b6cf",
		-- url = "#5de4c7",
		-- tab_bar = {
		-- 	background = "#101014",
		-- 	active_tab = {
		-- 		fg = "#3d59a1",
		-- 		background = "#16161e",
		-- 		bold = true,
		-- 	},
		--   inactive_tab = {
		--     fg = "#787c99",
		--     bg = "#16161e",
		--     bold = true,
		--   },
		-- },
		-- Define other colors as needed
	},
	-- enable_kitty_graphics = false,
	-- https://github.com/wez/wezterm/issues/1772
	enable_wayland = false,
	color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" },
	hide_tab_bar_if_only_one_tab = true,
	adjust_window_size_when_changing_font_size = false,
	selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	use_fancy_tab_bar = false,
	exit_behavior = "CloseOnCleanExit",
	tab_bar_at_bottom = false,
	window_close_confirmation = "AlwaysPrompt",
	-- window_background_opacity = 0.8,
	disable_default_key_bindings = false,
	visual_bell = {
		fade_in_function = "EaseIn",
		fade_in_duration_ms = 150,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 150,
	},
	-- separate <Tab> <C-i>
	enable_csi_u_key_encoding = true,
}
return config
