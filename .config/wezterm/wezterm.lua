-- Pull in the wezterm API
---@type Wezterm
local wezterm = require('wezterm')

---@diagnostic disable-next-line: unused-local
wezterm.on('update-right-status', function(window, pane)
    window:set_right_status(window:active_workspace())
end)

-- This will hold the configuration.
---@class Config
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Macchiato'
config.font_size = 15.0
config.quit_when_all_windows_are_closed = false
config.default_prog = { '/opt/homebrew/bin/zsh', '-li' }
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 120
config.initial_rows = 36
config.scrollback_lines = 100000
config.enable_scroll_bar = true
config.macos_window_background_blur = 10
config.window_decorations = 'RESIZE'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.warn_about_missing_glyphs = false
config.window_content_alignment = {
    horizontal = 'Left',
    vertical = 'Top',
}
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Setup modules
require('keys').setup(config)
require('launch_menu').setup(config)
require('transparency').setup(config)
require('hyperlinks').setup()

-- and finally, return the configuration to wezterm
return config
