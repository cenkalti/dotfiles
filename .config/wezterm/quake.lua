local wezterm = require('wezterm')

local M = {}

-- toggle shows or hides a dropdown pane along the bottom of the active tab,
-- remembering the pane per tab in wezterm.GLOBAL[opts.state]. Distinct state
-- keys are what let two dropdowns coexist in the same tab.
--
-- opts:
--   state       GLOBAL key holding this dropdown's per-tab pane ids
--   size        split size, as a fraction of the tab
--   top_level   split the whole tab rather than the focused pane
--   cwd, args   passed to the split; nil inherits the cwd / default_prog
--   focus_first when the pane exists but isn't focused, focus it instead of
--               closing it, so closing always takes a second deliberate press
local function toggle(window, pane, opts)
    wezterm.GLOBAL[opts.state] = wezterm.GLOBAL[opts.state] or {}
    local panes = wezterm.GLOBAL[opts.state]
    local tab = window:active_tab()
    local tab_key = tostring(tab:tab_id())
    local existing_id = panes[tab_key]

    if existing_id then
        for _, info in ipairs(tab:panes_with_info()) do
            if info.pane:pane_id() == existing_id then
                if opts.focus_first and window:active_pane():pane_id() ~= existing_id then
                    info.pane:activate()
                    return
                end
                info.pane:activate()
                window:perform_action(
                    wezterm.action.CloseCurrentPane({ confirm = false }),
                    info.pane
                )
                panes[tab_key] = nil
                return
            end
        end
        panes[tab_key] = nil
    end

    local new_pane = pane:split({
        direction = 'Bottom',
        size = opts.size,
        top_level = opts.top_level,
        cwd = opts.cwd,
        args = opts.args,
    })
    panes[tab_key] = new_pane:pane_id()
end

function M.setup(_)
    wezterm.on('toggle-quake', function(window, pane)
        toggle(window, pane, { state = 'quake_panes', size = 0.2 })
    end)

    -- A disposable Claude Code console for managing agents. Deliberately not a
    -- harness agent: no record, no workspace, no tmux session, nothing to clean
    -- up. It runs in a temp dir, which must not match any agent's cwd ($HOME is
    -- the dotfiles repo agent), or the SessionStart hook would inject that
    -- agent's identity and context into this session.
    wezterm.on('toggle-quake-agent', function(window, pane)
        toggle(window, pane, {
            state = 'quake_agent_panes',
            size = 0.4,
            top_level = true,
            focus_first = true,
            args = {
                '/opt/homebrew/bin/zsh',
                '-c',
                'd="${TMPDIR:-/tmp}/quake"; mkdir -p "$d" && cd "$d" && exec claude',
            },
        })
    end)
end

return M
