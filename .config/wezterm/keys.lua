local wezterm = require('wezterm')

local M = {}

function M.setup(config)
    local keys = config.keys or {}
    local new_keys = {
        { mods = 'SHIFT', key = 'Enter', action = wezterm.action({ SendString = '\x1b\r' }) }, --- Added by Claude Code
        {
            mods = 'SUPER',
            key = 'l',
            action = wezterm.action.ShowLauncherArgs({ title = 'Projects', flags = 'FUZZY|LAUNCH_MENU_ITEMS' }),
        },
        { mods = 'SUPER', key = 'o', action = wezterm.action.ShowTabNavigator },
        { mods = 'SHIFT|ALT', key = '{', action = wezterm.action.MoveTabRelative(-1) },
        { mods = 'SHIFT|ALT', key = '}', action = wezterm.action.MoveTabRelative(1) },
        {
            mods = 'SUPER',
            key = 'k',
            action = wezterm.action.Multiple({
                wezterm.action.SendKey({ mods = 'CTRL', key = 'C' }),
                wezterm.action.SendKey({ mods = 'CTRL', key = 'L' }),
                wezterm.action.ClearScrollback('ScrollbackAndViewport'),
            }),
        },
        { mods = 'SUPER|ALT', key = 't', action = wezterm.action.EmitEvent('toggle-transparency') },

        -- Workspace Switcher
        {
            mods = 'SUPER',
            key = 's',
            action = wezterm.action.ShowLauncherArgs({ title = 'Workspaces', flags = 'WORKSPACES' }),
        },
        {
            mods = 'SUPER',
            key = ']',
            action = wezterm.action.SwitchWorkspaceRelative(1),
        },
        {
            mods = 'SUPER',
            key = '[',
            action = wezterm.action.SwitchWorkspaceRelative(-1),
        },

        -- New Workspace
        {
            mods = 'SUPER',
            key = 'S',
            action = wezterm.action.PromptInputLine({
                description = wezterm.format({
                    { Attribute = { Intensity = 'Bold' } },
                    { Foreground = { AnsiColor = 'Fuchsia' } },
                    { Text = 'Enter name for new workspace' },
                }),
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        ---@diagnostic disable-next-line: param-type-mismatch
                        window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
                    end
                end),
            }),
        },

        -- Rename Workspace
        {
            mods = 'SUPER',
            key = 'R',
            action = wezterm.action.PromptInputLine({
                description = wezterm.format({
                    { Attribute = { Intensity = 'Bold' } },
                    { Foreground = { AnsiColor = 'Fuchsia' } },
                    { Text = 'Rename workspace' },
                }),
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        ---@diagnostic disable-next-line: param-type-mismatch
                        window:perform_action(
                            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line),
                            pane
                        )
                    end
                end),
            }),
        },

        -- Jump to previous/next shell prompt
        {
            mods = 'SHIFT',
            key = 'UpArrow',
            action = wezterm.action.ScrollToPrompt(-1),
        },
        {
            mods = 'SHIFT',
            key = 'DownArrow',
            action = wezterm.action.ScrollToPrompt(1),
        },

        -- My AI shell
        {
            mods = 'SUPER|SHIFT',
            key = 't',
            action = wezterm.action.SpawnCommandInNewTab({
                args = { '/Users/cenk/projects/gi/gi-shell' },
            }),
        },

        -- Disable Ctrl+Shift+N and Ctrl+Shift+P for Neovim tab navigation
        { mods = 'CTRL|SHIFT', key = 'N', action = wezterm.action.DisableDefaultAssignment },
        { mods = 'CTRL|SHIFT', key = 'P', action = wezterm.action.DisableDefaultAssignment },
    }

    -- Merge existing keys with new keys
    for _, key in ipairs(new_keys) do
        table.insert(keys, key)
    end

    config.keys = keys
end

return M