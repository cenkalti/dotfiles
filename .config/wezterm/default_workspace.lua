local wezterm = require('wezterm')

local M = {}

local DEFAULT = 'default'

-- quit_when_all_windows_are_closed = false keeps WezTerm alive with zero
-- windows. Whatever opens the next one -- Cmd+N, Cmd+T, the dock icon, `wezterm
-- cli spawn --new-window` -- joins the workspace that was active before the app
-- emptied out, which is almost always a stale agent workspace rather than
-- 'default'.
--
-- None of those paths is reachable from config.keys: with no window focused the
-- macOS menu handles the keystroke and Lua never sees it. There is also no
-- window-created event to hang this off; window-config-reloaded fires only on
-- an actual config reload. So the correction has to be driven from the events
-- that a live window does emit, and it has to recognise the stale window on
-- sight rather than by having watched the app go empty.
--
-- Watching for the empty state is not an option regardless: it needs a timer,
-- and wezterm.time.call_after only honours the first timer scheduled during
-- config evaluation -- one re-armed from inside its own callback is silently
-- dropped (wezterm#3026). A self-rescheduling poll ticks exactly once and then
-- dies, so it can never observe a window count of zero.

-- Mux window ids are handed out monotonically, so the highest id seen so far is
-- a durable watermark: a window above it is one this config has not yet
-- observed. Recording it in GLOBAL is what makes that survive the config reload
-- that accompanies a new window. Scalars only -- GLOBAL hands back copies, so a
-- table mutated through a local reference would not persist.
--
-- The watermark has to be advanced by scanning every live mux window, not just
-- the one whose event we are handling. update-status fires only for the visible
-- GUI window; a mux window sitting in a non-active workspace (the dashboard,
-- most of the time) emits nothing at all. Keying off the event's own window
-- would leave those unrecorded, and one of them would then look brand new the
-- moment it became the last window standing.
local function claim_for_default()
    local ok, windows = pcall(wezterm.mux.all_windows)
    if not ok then return end

    local high = wezterm.GLOBAL.max_window_id or -1
    local top = high
    for _, w in ipairs(windows) do
        local got, id = pcall(w.window_id, w)
        if got and id > top then top = id end
    end
    if top > high then wezterm.GLOBAL.max_window_id = top end

    -- Exactly one workspace, one window and one tab is the signature of a
    -- window born into an empty app. Testing its id against the watermark as it
    -- stood *before* this scan is what separates that from a session
    -- hand-pruned down to its last tab, in a workspace named on purpose: the
    -- survivor was recorded long ago, so it is left alone.
    if #windows ~= 1 then return end
    local got, id = pcall(windows[1].window_id, windows[1])
    if not got or id <= high then return end
    local named, names = pcall(wezterm.mux.get_workspace_names)
    if not named or #names ~= 1 then return end
    local tabbed, tabs = pcall(windows[1].tabs, windows[1])
    if not tabbed or #tabs ~= 1 then return end

    local stale = names[1]
    if stale == DEFAULT then return end
    -- Renaming beats moving the window into 'default' and switching the GUI to
    -- follow. The old code did the latter and the switch was being dropped --
    -- "unhandled perform: SwitchToWorkspace" in the gui log -- because the
    -- window is not ready to service an action that soon after it appears. A
    -- rename is one mux call with no GUI handle involved, no second shell, and
    -- no flicker. The single-workspace guard proves 'default' is free, so the
    -- target name cannot collide.
    local renamed, err = pcall(wezterm.mux.rename_workspace, stale, DEFAULT)
    if not renamed then
        wezterm.log_error('default_workspace: rename ' .. stale .. ' -> ' .. DEFAULT .. ' failed: ' .. tostring(err))
    end
end

function M.setup()
    -- Both handlers run in the persistent Lua state, so neither is subject to
    -- the timer restriction above. focus lands the rename the instant the
    -- window is raised; update-status is the backstop for a window that somehow
    -- opens without taking focus, and costs one mux scan per second otherwise.
    -- Both are indifferent to whether Cmd+N or Cmd+T opened it.
    wezterm.on('window-focus-changed', claim_for_default)
    wezterm.on('update-status', claim_for_default)
end

return M
