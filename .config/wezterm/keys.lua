local wezterm = require('wezterm')

local M = {}

function M.setup(config)
    config.leader = { mods = 'CTRL', key = 'a', timeout_milliseconds = 1000 }

    config.keys = {
        {
            mods = 'SUPER',
            key = 'l',
            action = wezterm.action.ShowLauncherArgs({ title = 'Projects', flags = 'FUZZY|LAUNCH_MENU_ITEMS' }),
        },
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
                        window:perform_action(wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line), pane)
                    end
                end),
            }),
        },
    }
end

return M