-- Respawn the active window: open a fresh GUI window and move every tab into
-- it, in order, leaving the old window empty so it closes itself. Works around
-- a window whose left status has stopped updating -- the panes and their
-- processes are moved, not restarted, so nothing is lost.
--
-- Tabs are moved with `wezterm cli`: the Lua API can create a window from a
-- pane but cannot move a pane into an *existing* window, which is what tabs two
-- and up need. The calls are chained into one `sh -c` so they run in order
-- without blocking the Lua thread.
local wezterm = require('wezterm')

local M = {}

local wezterm_bin = wezterm.executable_dir .. '/wezterm'

local function quote(s)
    return "'" .. s:gsub("'", [['\'']]) .. "'"
end

local function respawn(window, pane)
    local mux_window = window:mux_window()
    local workspace = mux_window:get_workspace()
    local dimensions = window:get_dimensions()
    local active_pane_id = pane:pane_id()

    -- Snapshot the layout before anything moves: pane ids survive a move, tab
    -- and window ids do not, so every command below is keyed on a pane id.
    local plan = {}
    for _, tab in ipairs(mux_window:tabs()) do
        local entry = { title = tab:get_title(), panes = {} }
        for _, info in ipairs(tab:panes_with_info()) do
            table.insert(entry.panes, { pane = info.pane, id = info.pane:pane_id(), top = info.top })
        end
        table.insert(plan, entry)
    end

    local _, new_window = plan[1].panes[1].pane:move_to_new_window(workspace)
    local window_id = new_window:window_id()

    local cmds = {}
    local function cli(...)
        local parts = { quote(wezterm_bin), 'cli' }
        for _, arg in ipairs({ ... }) do
            table.insert(parts, arg)
        end
        table.insert(cmds, table.concat(parts, ' '))
    end

    for i, entry in ipairs(plan) do
        local panes = entry.panes
        if i > 1 then
            cli('move-pane-to-new-tab', '--pane-id', panes[1].id, '--window-id', window_id)
        end
        for j = 2, #panes do
            -- Splits are rebuilt as a chain off the tab's first pane: a two-pane
            -- tab keeps its orientation, deeper layouts flatten.
            local direction = panes[j].top > panes[j - 1].top and '--bottom' or '--right'
            cli('split-pane', '--pane-id', panes[1].id, '--move-pane-id', panes[j].id, direction)
        end
        if entry.title ~= '' then
            cli('set-tab-title', '--pane-id', panes[1].id, quote(entry.title))
        end
    end
    cli('activate-pane', '--pane-id', active_pane_id)

    wezterm.background_child_process({ '/bin/sh', '-c', table.concat(cmds, '; ') })

    -- The GUI window is created a beat after the mux window it belongs to, so
    -- match the geometry on a later tick. There is no way to read a window's
    -- screen position from Lua, so only the size is carried over.
    wezterm.time.call_after(0.2, function()
        local gui_window = new_window:gui_window()
        if not gui_window then
            return
        end
        if dimensions.is_full_screen then
            gui_window:toggle_fullscreen()
        else
            gui_window:set_inner_size(dimensions.pixel_width, dimensions.pixel_height)
        end
    end)
end

function M.setup()
    wezterm.on('respawn-window', respawn)
end

return M
