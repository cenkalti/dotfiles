-- Land on the last used workspace when the active one is destroyed.
--
-- A workspace dies with its last window, and WezTerm hands the session to
-- whichever workspace it happens to find next -- reconcile_workspace() walks
-- mux.iter_workspaces() and takes the first non-empty one, which from the
-- outside looks random. This keeps a most-recently-used stack of workspace
-- names and, on spotting that kind of involuntary switch, redirects to the most
-- recent workspace still standing.
--
-- WezTerm has no workspace-changed event, so the switch is spotted by polling:
-- update-status ticks about once a second, and window-focus-changed catches the
-- new window sooner than that. Each tick returns immediately when the workspace
-- in front is the one it saw last.
--
-- The active workspace is a single global value -- window:active_workspace() is
-- mux.active_workspace(), not a property of the window it is called on -- so the
-- state below is global rather than keyed by window.

local wezterm = require('wezterm')

local M = {}

local SEP = '\n'

-- State lives in wezterm.GLOBAL so it survives the config reload that opening a
-- window triggers, which is exactly when workspaces come and go. Scalars only,
-- and strictly so: a table assigned to GLOBAL does not survive the round trip
-- (the reason default_workspace.lua keeps a bare integer), and it fails
-- silently -- the read hands back a value that iterates as empty. So both name
-- lists are stored newline-joined, a separator no workspace name can contain.
local function split(s)
    local list = {}
    for name in tostring(s or ''):gmatch('[^' .. SEP .. ']+') do
        list[#list + 1] = name
    end
    return list
end

-- alive reports which workspaces still hold a window with at least one tab.
--
-- Not mux.get_workspace_names(): a workspace WezTerm has already switched off
-- keeps its name in that list for a second or two, because the emptied mux
-- window behind it is reaped later. The GUI switches away the moment the window
-- loses its last tab, so counting tabs is what makes the death visible on the
-- same tick as the switch it caused -- polling the name list instead just sees
-- the workspace it left still standing and concludes the user asked for this.
local function alive()
    local ok, windows = pcall(wezterm.mux.all_windows)
    if not ok then
        return nil
    end
    local live = {}
    for _, w in ipairs(windows) do
        local got, tabs = pcall(w.tabs, w)
        if got and #tabs > 0 then
            local named, ws = pcall(w.get_workspace, w)
            if named then
                live[ws] = true
            end
        end
    end
    return live
end

-- record puts ws on top of the stack, dropping workspaces that are gone so a
-- long session cannot accumulate dead names.
local function record(ws, live, names)
    local mru = { ws }
    for _, n in ipairs(split(wezterm.GLOBAL.workspace_mru)) do
        if n ~= ws and live[n] then
            mru[#mru + 1] = n
        end
    end
    wezterm.GLOBAL.workspace_mru = table.concat(mru, SEP)
    wezterm.GLOBAL.workspace_last = ws
    wezterm.GLOBAL.workspace_names = names
end

local function follow(window)
    if not window then
        return
    end
    local ok, ws = pcall(window.active_workspace, window)
    if not ok or not ws or ws == '' then
        return
    end
    local live = alive()
    if not live then
        return
    end
    local listed, names = pcall(wezterm.mux.get_workspace_names)
    names = listed and table.concat(names, SEP) or ''

    local prev = wezterm.GLOBAL.workspace_last
    if ws == prev then
        wezterm.GLOBAL.workspace_names = names
        return
    end

    -- Renaming the workspace we are sitting in (cmd-shift-r, or
    -- default_workspace's claim of a stale name) retires the old name too, and
    -- must not be read as its death. A rename is the one case where the name now
    -- in front did not exist a tick ago; every switch, forced or not, lands on a
    -- workspace that was already there.
    local known = false
    for _, n in ipairs(split(wezterm.GLOBAL.workspace_names)) do
        if n == ws then
            known = true
            break
        end
    end

    if prev and known and not live[prev] then
        for _, n in ipairs(split(wezterm.GLOBAL.workspace_mru)) do
            if n ~= prev and live[n] then
                -- The stack's top entry below the dead workspace is the one the
                -- user came from. If WezTerm already picked it, leave it be.
                if n ~= ws then
                    -- mux-level rather than window:perform_action: the window
                    -- this event came from may have been created moments ago to
                    -- show WezTerm's pick, and a window that new drops
                    -- SwitchToWorkspace on the floor ("unhandled perform" in the
                    -- gui log) -- the trap default_workspace.lua documents.
                    local switched, err = pcall(wezterm.mux.set_active_workspace, n)
                    if not switched then
                        wezterm.log_error('workspace_mru: switch to ' .. n .. ' failed: ' .. tostring(err))
                    end
                    record(n, live, names)
                    return
                end
                break
            end
        end
    end

    record(ws, live, names)
end

function M.setup()
    wezterm.on('update-status', follow)
    wezterm.on('window-focus-changed', follow)
end

return M
