-- Keep this file minimal: config values and module wiring only.
-- New behavior belongs in its own *.lua module with an M.setup() entry point,
-- required from the setup block at the bottom.

---@type Wezterm
local wezterm = require('wezterm')

local function cwd_basename(cwd_uri)
    local cwd = cwd_uri and cwd_uri.file_path or ''
    return cwd:match('([^/]+)/*$') or ''
end

wezterm.on('format-window-title', function(tab, pane)
    local basename = cwd_basename(pane.current_working_dir)
    return basename ~= '' and basename or tab.active_pane.title
end)

-- `agent jump` sets agent_jump to a unique timestamp on the target pane's tty after activating it, so raise the window to the foreground.
wezterm.on('user-var-changed', function(window, _, name, value)
    if name == 'agent_jump' and value ~= '' then
        window:focus()
    end
end)

wezterm.on('update-status', function(window, pane)
    local workspace = window:active_workspace()
    window:set_left_status(workspace ~= 'default' and ' ' .. workspace .. ' ' or '')

    local basename = ''
    if pane then
        local ok, cwd = pcall(pane.get_current_working_dir, pane)
        if ok then
            basename = cwd_basename(cwd)
        end
    end
    window:set_right_status(basename ~= '' and ' ' .. basename .. ' ' or '')
end)

-- This will hold the configuration.
---@class Config
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font('Monaspace Neon NF')
config.font_rules = {
    {
        intensity = 'Normal',
        italic = true,
        font = wezterm.font('Monaspace Radon NF', { style = 'Normal' }),
    },
    {
        intensity = 'Bold',
        italic = true,
        font = wezterm.font('Monaspace Radon NF', { style = 'Normal', weight = 'Bold' }),
    },
}
config.font_size = 16.0
config.window_frame = {
    font = wezterm.font('Roboto'),
    font_size = 16.0,
}
config.quit_when_all_windows_are_closed = false
config.default_prog = { '/opt/homebrew/bin/zsh', '-li' }
config.adjust_window_size_when_changing_font_size = false
config.initial_cols = 120
config.initial_rows = 36
config.scrollback_lines = 100000
config.enable_scroll_bar = true
config.window_decorations = 'RESIZE'
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.warn_about_missing_glyphs = false
config.window_padding = { top = 0, left = 0 }

package.path = wezterm.home_dir .. '/projects/harness/wezterm/?.lua;' .. package.path

-- Setup modules
require('keys').setup(config)
require('launch_menu').setup(config)
require('transparency').setup(config)
require('quake').setup(config)
require('hyperlinks').setup()
require('tab_colors').setup()
require('tab_toggle').setup()
require('file_picker').setup()
require('default_workspace').setup()
require('work').setup()

-- and finally, return the configuration to wezterm
return config
