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

wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

return config


