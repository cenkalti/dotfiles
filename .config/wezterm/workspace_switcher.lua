-- fzf-based workspace switcher.
--
-- Mirrors the agent picker (work.lua's work-pick-agent): spawn an fzf TUI in a
-- transient tab and route the selection back via an OSC 1337 user-var, since
-- fzf can't run inside the WezTerm Lua event loop. The workspace list comes
-- from the mux. Selecting an existing workspace switches to it; typing a name
-- that matches nothing creates it. Bind a key to EmitEvent('pick-workspace').

local wezterm = require('wezterm')
local spawn = require('spawn')

local M = {}

local script = wezterm.config_dir .. '/workspace-pick.sh'

function M.setup()
    wezterm.on('pick-workspace', function(window, pane)
        local mux_window = window:mux_window()
        if not mux_window then
            return
        end
        local names = wezterm.mux.get_workspace_names()
        table.sort(names)
        local args = { script }
        for _, n in ipairs(names) do
            table.insert(args, n)
        end
        mux_window:spawn_tab({ args = spawn.wrap(args) })
    end)

    -- The picker emits one salted OSC, pick_workspace = "<salt> <workspace>"
    -- (the salt forces a fresh value so WezTerm doesn't dedupe the event). We
    -- only switch here; the picker closes itself by exiting (a mux-level pane
    -- teardown, reliable regardless of which workspace the GUI shows). Doing the
    -- close from Lua would race/clobber the switch, so we don't.
    wezterm.on('user-var-changed', function(window, pane, name, value)
        if name ~= 'pick_workspace' or not value or value == '' then
            return
        end
        local ws = value:match('^%S+%s+(.+)$')
        if not ws or ws == '' then
            return
        end
        local exists = false
        for _, n in ipairs(wezterm.mux.get_workspace_names()) do
            if n == ws then
                exists = true
                break
            end
        end
        -- Pre-create a new workspace headlessly; mux.spawn_window needs no live
        -- pane (unlike SwitchToWorkspace's spawn field). Then it's a plain switch.
        if not exists then
            wezterm.mux.spawn_window({ workspace = ws, args = { '/opt/homebrew/bin/zsh', '-li' } })
        end
        window:perform_action(wezterm.action.SwitchToWorkspace({ name = ws }), pane)
    end)
end

return M
