-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Macchiato'
config.font_size = 13.0
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

-- Read ~/projects dir and add each dir to launch menu
config.launch_menu = {}
local workspace_dirs = { '~/projects', '~/.config' }
for _, workspace_dir in ipairs(workspace_dirs) do
    local handle = io.popen('ls -1 ' .. workspace_dir)
    if handle then
        for project_dir in handle:lines() do
            table.insert(config.launch_menu, {
                label = project_dir,
                args = {
                    '/opt/homebrew/bin/zsh',
                    '-lic',
                    'cd '
                        .. workspace_dir
                        .. '/'
                        .. project_dir
                        .. ' && exec /opt/homebrew/bin/nvim -c "Telescope find_files"',
                },
            })
        end
        handle:close()
    end
end

local default_windows_background_opacity = 0.95
local default_text_background_opacity = 0.5
config.window_background_opacity = default_windows_background_opacity
config.text_background_opacity = default_text_background_opacity
local transparency_enabled = true
wezterm.on('toggle-transparency', function(window, _)
    if transparency_enabled then
        transparency_enabled = false
        window:set_config_overrides({
            window_background_opacity = 1.0,
            text_background_opacity = 1.0,
        })
    else
        transparency_enabled = true
        window:set_config_overrides({
            window_background_opacity = default_windows_background_opacity,
            text_background_opacity = default_text_background_opacity,
        })
    end
end)

config.keys = {
    {
        key = 'l',
        mods = 'SUPER',
        action = wezterm.action.ShowLauncherArgs({ title = 'Projects', flags = 'FUZZY|LAUNCH_MENU_ITEMS' }),
    },
    { key = '{', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative(-1) },
    { key = '}', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative(1) },
    {
        key = 'k',
        mods = 'SUPER',
        action = wezterm.action.Multiple({
            wezterm.action.SendKey({ key = 'C', mods = 'CTRL' }),
            wezterm.action.SendString('return 0\n'),
            wezterm.action.SendKey({ key = 'L', mods = 'CTRL' }),
            wezterm.action.ClearScrollback('ScrollbackAndViewport'),
        }),
    },
    { key = 't', mods = 'SUPER|ALT', action = wezterm.action.EmitEvent('toggle-transparency') },
}

-- Integration for https://github.com/folke/zen-mode.nvim
wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == 'ZEN_MODE' then
        local incremental = value:find('+')
        local number_value = tonumber(value)
        if incremental ~= nil then
            while number_value > 0 do
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

-- and finally, return the configuration to wezterm
return config
