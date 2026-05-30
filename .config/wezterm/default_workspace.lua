local wezterm = require('wezterm')

local M = {}

-- When wezterm has 0 windows then a new one is created, it joins the last
-- active workspace. Track the empty state and reassign the (single) new
-- window's mux + gui to 'default' on the next focus event or poll tick.
local function move_first_to_default_if_was_empty()
    if not wezterm.GLOBAL.was_empty then return end
    local windows = wezterm.mux.all_windows()
    if #windows ~= 1 then return end
    wezterm.GLOBAL.was_empty = false
    local mw = windows[1]
    if mw:get_workspace() == 'default' then return end
    local gw = mw:gui_window()
    local pane = mw:active_pane()
    mw:set_workspace('default')
    if gw and pane then
        gw:perform_action(wezterm.action.SwitchToWorkspace({ name = 'default' }), pane)
    end
end

function M.setup()
    if wezterm.GLOBAL.had_window == nil then wezterm.GLOBAL.had_window = false end
    if wezterm.GLOBAL.was_empty == nil then wezterm.GLOBAL.was_empty = false end
    wezterm.GLOBAL.default_poll_gen = (wezterm.GLOBAL.default_poll_gen or 0) + 1
    local my_gen = wezterm.GLOBAL.default_poll_gen
    local function poll()
        if wezterm.GLOBAL.default_poll_gen ~= my_gen then return end
        if #wezterm.mux.all_windows() > 0 then
            wezterm.GLOBAL.had_window = true
            move_first_to_default_if_was_empty()
        elseif wezterm.GLOBAL.had_window then
            wezterm.GLOBAL.was_empty = true
        end
        wezterm.time.call_after(1, poll)
    end
    poll()

    wezterm.on('window-focus-changed', function(_, _) move_first_to_default_if_was_empty() end)
end

return M
