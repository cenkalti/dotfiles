local wezterm = require('wezterm')
local work = require('work')

local M = {}

local skip_close_titles = { 'zsh', 'tmux', 'nvim', 'lazygit', 'agent', 'glow' }
local skip_close_set = {}
for _, name in ipairs(skip_close_titles) do
    skip_close_set[name] = true
end

function M.setup(config)
    local keys = config.keys or {}
    local new_keys = {
        -- Give alt-enter back to the terminal. WezTerm's default binds it to
        -- ToggleFullScreen and swallows it; DisableDefaultAssignment drops that
        -- registration so the key press is propagated to the pane instead.
        --
        -- There used to be a shift-enter binding here sending ESC CR, so that
        -- Claude Code could see a newline key at all. It is gone because
        -- ~/.tmux.conf now turns on extended keys: a program that asks for them
        -- receives shift-enter and alt-enter as distinct keys, and no longer
        -- needs a hand-rolled sequence standing in for one of them.
        { mods = 'ALT', key = 'Enter', action = wezterm.action.DisableDefaultAssignment },

        -- Only copy when there is a selection; otherwise leave the clipboard untouched.
        {
            mods = 'SUPER',
            key = 'c',
            action = wezterm.action_callback(function(window, pane)
                if window:get_selection_text_for_pane(pane) ~= '' then
                    window:perform_action(wezterm.action.CopyTo('Clipboard'), pane)
                end
            end),
        },
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
        { mods = 'SUPER', key = 'i', action = wezterm.action.EmitEvent('work-toggle-github') },
        { mods = 'SUPER', key = 'a', action = wezterm.action.EmitEvent('work-toggle-agent') },
        { mods = 'SUPER|SHIFT', key = 'a', action = wezterm.action.EmitEvent('work-pick-agent') },
        { mods = 'SUPER', key = 'y', action = wezterm.action.EmitEvent('work-pane-to-agent') },
        { mods = 'SUPER|SHIFT', key = 'y', action = wezterm.action.EmitEvent('work-pane-to-new-agent') },
        { mods = 'SUPER', key = 'b', action = wezterm.action.EmitEvent('work-show-browser') },
        -- ⌘G / ⌘E / ⌘T open lazygit, nvim and a shell for the agent in the
        -- current pane, as tmux windows inside that agent's own session shown
        -- in the agent's own tab — identically whether the agent is on this
        -- machine or another. Their positions are fixed: lazygit immediately
        -- right of the agent, the editor right of lazygit, shells appended
        -- after. In a pane that is not an agent's, ⌘G and ⌘E spawn a plain
        -- local tab on the same ordering relative to the current tab, and ⌘T
        -- is the ordinary new tab.
        -- Mechanism lives in the harness repo (wezterm/work.lua), because it
        -- knows about tmux session naming and how a host is reached.
        { mods = 'SUPER', key = 'g', action = wezterm.action.EmitEvent('work-open-lazygit') },
        { mods = 'SUPER', key = 'e', action = wezterm.action.EmitEvent('work-open-nvim') },
        { mods = 'SUPER', key = 't', action = wezterm.action.EmitEvent('work-open-shell') },
        -- Adding SHIFT is the escape hatch: always a native tab running the
        -- program here, never the agent's tmux. The one that matters is a
        -- remote agent, where the plain key puts the tool on the far host.
        { mods = 'SUPER|SHIFT', key = 'g', action = wezterm.action.EmitEvent('work-open-lazygit-here') },
        { mods = 'SUPER|SHIFT', key = 'e', action = wezterm.action.EmitEvent('work-open-nvim-here') },
        { mods = 'SUPER|SHIFT', key = 't', action = wezterm.action.EmitEvent('work-open-shell-here') },
        -- The file pickers moved off SUPER|SHIFT g/e to make room for the
        -- above. Nothing else wanted SUPER|ALT g/e.
        { mods = 'SUPER|ALT', key = 'e', action = wezterm.action.EmitEvent('file-picker-workspace') },
        { mods = 'SUPER|ALT', key = 'g', action = wezterm.action.EmitEvent('file-picker-glow') },
        { mods = 'SUPER|ALT', key = '=', action = wezterm.action.EmitEvent('increase-transparency') },
        { mods = 'SUPER|ALT', key = '-', action = wezterm.action.EmitEvent('decrease-transparency') },
        { mods = 'SUPER|ALT|SHIFT', key = '+', action = wezterm.action.EmitEvent('decrease-blur') },
        { mods = 'SUPER|ALT|SHIFT', key = '_', action = wezterm.action.EmitEvent('increase-blur') },
        { mods = 'SUPER', key = 'j', action = wezterm.action.EmitEvent('toggle-quake') },
        -- cmd-opt rather than cmd-shift: Notion holds cmd-shift-j as a
        -- system-wide hotkey, so WezTerm never sees that chord.
        { mods = 'SUPER|ALT', key = 'j', action = wezterm.action.EmitEvent('toggle-quake-agent') },
        {
            mods = 'SUPER',
            key = 'u',
            action = wezterm.action.SpawnCommandInNewTab({ args = { os.getenv('HOME') .. '/.local/bin/claude-usage' } }),
        },

        -- Workspace Switcher (fzf picker; create on no-match)
        {
            mods = 'SUPER',
            key = 's',
            action = wezterm.action.EmitEvent('pick-workspace'),
        },
        {
            mods = 'SUPER',
            key = ']',
            action = wezterm.action_callback(function(window, pane)
                work.switch_workspace(window, pane, 1)
            end),
        },
        {
            mods = 'SUPER',
            key = '[',
            action = wezterm.action_callback(function(window, pane)
                work.switch_workspace(window, pane, -1)
            end),
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
                action = wezterm.action_callback(function(_, _, line)
                    -- line is nil when the prompt is cancelled and '' when it
                    -- is submitted empty; renaming to '' would strand the
                    -- workspace under an unselectable name.
                    if line and line ~= '' then
                        wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
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

        -- "My AI shell" lived here on SUPER|SHIFT t, spawning
        -- /Users/cenk/projects/gi/gi-shell. Removed for two reasons: that
        -- binary does not exist any more (the spawn failed with ENOENT), and
        -- the duplicate key silently shadowed the shell escape hatch above,
        -- since a later entry wins. Rebind it on a free key to bring it back —
        -- of the letters, SUPER|SHIFT b/c/d/f/h/i/j/k/l/m/o/p/q/r/s/u/v/x/z
        -- are all unused.

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

        -- Rebuild this window: move every tab into a fresh window and let the
        -- emptied one close. Recovers a window whose left status has frozen.
        { mods = 'SUPER|SHIFT', key = 'n', action = wezterm.action.EmitEvent('respawn-window') },

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
            action = wezterm.action.SelectTextAtMouseCursor('SemanticZone'),
            mods = 'NONE',
        },
    }
end

return M