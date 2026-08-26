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

local DEFAULT = 'default'
local script = wezterm.config_dir .. '/workspace-pick.sh'

-- pick_return maps the picker pane's id -> the MuxTab that was active when we
-- spawned it. The picker's tab is transient, and when it dies WezTerm promotes
-- whichever neighbour it likes; re-activating the remembered tab first puts the
-- user back where they pressed cmd-s.
--
-- Keyed by pane id rather than window id because a switch rebinds the GUI window
-- to a different mux window, so by the time we restore, window:window_id() no
-- longer names the window the picker's tab lives in. Mirrors work.lua's table of
-- the same name.
local pick_return = {}

function M.setup()
    wezterm.on('pick-workspace', function(window, pane)
        local mux_window = window:mux_window()
        if not mux_window then
            return
        end
        local names = wezterm.mux.get_workspace_names()
        table.sort(names)
        -- 'default' goes first so an untouched picker -- no typing, no cursor
        -- movement -- lands there on Enter, which is what replaced the old
        -- cmd-shift-d binding. The picker passes --tiebreak index, so fzf keeps
        -- this order for an empty query. It is injected unconditionally: the
        -- workspace may not exist yet, and the user-var handler below creates
        -- any name it doesn't recognise.
        local args = { script, DEFAULT }
        for _, n in ipairs(names) do
            if n ~= DEFAULT then
                table.insert(args, n)
            end
        end
        local return_tab = mux_window:active_tab()
        local _, tab_pane = mux_window:spawn_tab({ args = spawn.wrap(args) })
        if return_tab and tab_pane then
            pick_return[tab_pane:pane_id()] = return_tab
        end
    end)

    -- The picker emits one salted OSC, pick_workspace = "<salt> <workspace>"
    -- (the salt forces a fresh value so WezTerm doesn't dedupe the event). It
    -- emits on every exit path, cancel included, where the workspace half is
    -- empty: there is no switch to make then, but the focus still has to be put
    -- back, and this OSC is the only notice we get that the picker is done.
    --
    -- We still don't close the picker here; it closes itself by exiting (a
    -- mux-level pane teardown, reliable regardless of which workspace the GUI
    -- shows), and a Lua close would race/clobber the switch. Restoring focus is
    -- safe in a way closing is not — by the time that tab exits it is no longer
    -- the active one, so nothing gets promoted in its place.
    wezterm.on('user-var-changed', function(window, pane, name, value)
        if name ~= 'pick_workspace' or not value or value == '' then
            return
        end
        -- %s (not %s+) and (.*) so a cancel's empty workspace still parses.
        local ws = value:match('^%S+%s(.*)$')
        if not ws then
            return
        end
        local back = pick_return[pane:pane_id()]
        pick_return[pane:pane_id()] = nil
        if back then
            pcall(back.activate, back)
        end
        if ws == '' then -- cancelled: focus restored, nothing to switch to
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
