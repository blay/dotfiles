local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local config = wezterm.config_builder()

config.color_scheme = 'Ayu Mirage'
--color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
config.font = wezterm.font 'JetBrains Mono'

config.scrollback_lines = 3500
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

return config
