local wezterm = require('wezterm')
local work = require('work')

local M = {}

local skip_close_titles = { 'zsh', 'tmux', 'nvim', 'lazygit', 'agent' }
local skip_close_set = {}
for _, name in ipairs(skip_close_titles) do
    skip_close_set[name] = true
end

function M.setup(config)
    local keys = config.keys or {}
    local new_keys = {
        { mods = 'SHIFT', key = 'Enter', action = wezterm.action.SendString('\x1b\r') }, --- Added by Claude Code
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
        { mods = 'SUPER', key = 'd', action = wezterm.action.EmitEvent('work-toggle-dashboard') },
        { mods = 'SUPER', key = 'a', action = wezterm.action.EmitEvent('work-toggle-agent') },
        { mods = 'SUPER|SHIFT', key = 'a', action = wezterm.action.EmitEvent('work-new-agent') },
        { mods = 'SUPER|CTRL', key = 'a', action = wezterm.action.EmitEvent('work-new-nameless-agent') },
        { mods = 'SUPER', key = 'g', action = wezterm.action.EmitEvent('toggle-lazygit') },
        { mods = 'SUPER', key = 'e', action = wezterm.action.EmitEvent('toggle-nvim') },
        { mods = 'SUPER|SHIFT', key = 'e', action = wezterm.action.EmitEvent('file-picker-workspace') },
        { mods = 'SUPER|SHIFT', key = 'g', action = wezterm.action.EmitEvent('file-picker-glow') },
        { mods = 'SUPER|ALT', key = '=', action = wezterm.action.EmitEvent('increase-transparency') },
        { mods = 'SUPER|ALT', key = '-', action = wezterm.action.EmitEvent('decrease-transparency') },
        { mods = 'SUPER|ALT|SHIFT', key = '+', action = wezterm.action.EmitEvent('increase-blur') },
        { mods = 'SUPER|ALT|SHIFT', key = '_', action = wezterm.action.EmitEvent('decrease-blur') },
        { mods = 'SUPER', key = 'j', action = wezterm.action.EmitEvent('toggle-quake') },
        { mods = 'SUPER', key = 'u', action = wezterm.action.SpawnCommandInNewTab({ args = { os.getenv('HOME') .. '/bin/claude-usage' } }) },

        -- Workspace Switcher
        {
            mods = 'SUPER',
            key = 's',
            action = wezterm.action.ShowLauncherArgs({ title = 'Workspaces', flags = 'WORKSPACES' }),
        },
        {
            mods = 'SUPER',
            key = ']',
            action = wezterm.action_callback(function(window, pane) work.switch_workspace(window, pane, 1) end),
        },
        {
            mods = 'SUPER',
            key = '[',
            action = wezterm.action_callback(function(window, pane) work.switch_workspace(window, pane, -1) end),
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

        -- Close current tab: skip confirmation when the pane title is one we trust.
        -- Matching on title (set via OSC 0/2) rather than the foreground process avoids
        -- the claude-versioned-shim basename and the LSP-server descendants under nvim.
        {
            mods = 'SUPER',
            key = 'w',
            action = wezterm.action_callback(function(window, pane)
                local title = pane:get_title() or ''
                window:perform_action(wezterm.action.CloseCurrentTab({ confirm = not skip_close_set[title] }), pane)
            end),
        },

        -- Close the entire window (all tabs/panes)
        {
            mods = 'SUPER|SHIFT',
            key = 'w',
            action = wezterm.action_callback(function(window, _)
                for _, tab in ipairs(window:mux_window():tabs()) do
                    for _, p in ipairs(tab:panes()) do
                        window:perform_action(wezterm.action.CloseCurrentPane({ confirm = false }), p)
                    end
                end
            end),
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

    config.mouse_bindings = {
        {
            event = { Down = { streak = 3, button = 'Left' } },
            action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
            mods = 'NONE',
        },
    }
end

return M