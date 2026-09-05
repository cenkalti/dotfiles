-- Land on the last used workspace when the active one is destroyed.
--
-- A workspace dies with its last window, and WezTerm hands the session to
-- whichever workspace it happens to find next -- reconcile_workspace() walks
-- mux.iter_workspaces() and takes the first non-empty one, which from the
-- outside looks random. This keeps a most-recently-used stack of workspace
-- names and, on spotting that kind of involuntary switch, redirects to the most
-- recent workspace still standing.
--
-- Driven by workspace-changed, which hands over both the name now in front and
-- the one it replaced. That pair used to be reconstructed by polling --
-- update-status ticking about once a second, with window-focus-changed to catch
-- a new window sooner -- and comparing against a copy of the previous name kept
-- in GLOBAL. The event reports the switch itself, so nothing has to be inferred
-- from a name changing between two samples, and it is emitted once for the
-- switch rather than once per window, so nothing has to be de-duplicated.
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
-- Not mux.get_workspace_names(): that list is derived from the mux windows, and
-- a window stripped of its last tab is reaped a moment after the switch it
-- caused, so a name can outlive the thing behind it. Counting tabs is what
-- makes the death visible while the switch it triggered is being handled.
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

-- record puts ws on top of the stack, with the workspace it displaced directly
-- beneath, dropping workspaces that are gone so a long session cannot
-- accumulate dead names.
--
-- Seeding from prior is what gets the workspace WezTerm started in onto the
-- stack. Nothing is recorded until the first switch, and that switch is the
-- only report the startup workspace ever generates -- it is never itself
-- switched to, so without this it would stay off the stack until the user
-- happened to return to it, and would be passed over as a landing spot. A prior
-- that is gone rather than merely left behind fails the liveness test here, the
-- same as any other dead name.
local function record(ws, live, names, prior)
    local mru = { ws }
    if prior and prior ~= ws and live[prior] then
        mru[#mru + 1] = prior
    end
    for _, n in ipairs(split(wezterm.GLOBAL.workspace_mru)) do
        if n ~= ws and n ~= prior and live[n] then
            mru[#mru + 1] = n
        end
    end
    wezterm.GLOBAL.workspace_mru = table.concat(mru, SEP)
    wezterm.GLOBAL.workspace_names = names
end

local function changed(ws, prior)
    if not ws or ws == '' then
        return
    end

    local live = alive()
    if not live then
        return
    end
    local listed, names = pcall(wezterm.mux.get_workspace_names)
    names = listed and table.concat(names, SEP) or ''

    -- Renaming the workspace we are sitting in (cmd-shift-r, or
    -- default_workspace's claim of a stale name) retires the old name too, and
    -- must not be read as its death. By the time this event arrives the two look
    -- alike from the old name alone -- after a rename and after a death it is
    -- equally gone from the workspace list and equally not live. What separates
    -- them is the name now in front: a rename is the one case where it did not
    -- exist before the change, since every switch, forced or not, lands on a
    -- workspace that was already there. workspace_names holds the list as it
    -- stood at the previous change, which is what makes that test possible.
    local known = false
    for _, n in ipairs(split(wezterm.GLOBAL.workspace_names)) do
        if n == ws then
            known = true
            break
        end
    end

    if prior and known and not live[prior] then
        for _, n in ipairs(split(wezterm.GLOBAL.workspace_mru)) do
            if n ~= prior and live[n] then
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
                    record(n, live, names, prior)
                    return
                end
                break
            end
        end
    end

    record(ws, live, names, prior)
end

function M.setup()
    wezterm.on('workspace-changed', changed)
end

return M
