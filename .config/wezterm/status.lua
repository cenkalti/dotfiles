local wezterm = require('wezterm')

local M = {}

local function cwd_basename(cwd_uri)
    local cwd = cwd_uri and cwd_uri.file_path or ''
    return cwd:match('([^/]+)/*$') or ''
end

-- The agent's handle, from the work_handle user var that `agent attach-pane`
-- tags on the pane it attaches (muxer.WriteAgentVars, or WriteRemoteAgentVars
-- for an agent on another machine, where the value is host-qualified). Empty
-- for any pane that is not an agent's.
local function agent_handle(pane)
    local vars = pane and pane.user_vars
    return vars and vars.work_handle or ''
end

function M.setup()
    -- Window title: which agent. Kept, but it no longer distinguishes
    -- anything: it existed so cmd-tab and Mission Control could pick an agent
    -- at the OS level, and with every agent a tab of one window there is one
    -- entry to pick. Harmless to leave, and correct for the case where a tab
    -- has been torn off into a window of its own. Falls back to the cwd
    -- basename for ordinary panes, then to the pane title.
    wezterm.on('format-window-title', function(tab, pane)
        local handle = agent_handle(pane)
        if handle ~= '' then
            return handle
        end
        local basename = cwd_basename(pane.current_working_dir)
        return basename ~= '' and basename or tab.active_pane.title
    end)

    wezterm.on('update-status', function(window, pane)
        -- Left status: the workspace name, always, including 'default'.
        --
        -- This used to be the agent's handle, with the workspace as a
        -- fallback. The tab bar names the agent now (INV-20), which freed this
        -- half for the question that came back with the change: agents stopped
        -- being workspaces, the workspace layer stayed as ordinary non-agent
        -- grouping, and nothing else was saying which one you are in.
        --
        -- 'default' is the exception, and it is suppressed for what it means
        -- rather than to save room: it is WezTerm's name for a workspace you
        -- never chose, so printing it says "you have not switched", which is
        -- the one answer worth nothing. Every other name is one you typed.
        --
        -- Every mux read below is pcall-guarded (same reasoning work.lua's own
        -- update-status handler documents): when the mux domain channel drops,
        -- active_workspace and get_user_vars raise, and an unguarded raise would
        -- abort this handler before set_left_status runs — freezing the bar at
        -- its last value until the channel recovers. Guarding lets a bad tick
        -- fall through to empty and the next healthy tick repaint.
        local ok, ws = pcall(window.active_workspace, window)
        local left = (ok and ws ~= 'default' and ws) or ''
        pcall(window.set_left_status, window, left ~= '' and ' ' .. left .. ' ' or '')

        -- Right status: the cwd basename. work_cwd first, because it is the
        -- only source for a remote agent — its path lives on the far host and
        -- is never reported as OSC 7. Deliberately not the other way round:
        -- OSC 7 sets the pane's *spawn* directory, so emitting a remote path
        -- there would aim a new tab at a directory this machine does not have.
        local basename = ''
        if pane then
            local okv, vars = pcall(pane.get_user_vars, pane)
            if okv and vars and vars.work_cwd and vars.work_cwd ~= '' then
                basename = vars.work_cwd:match('([^/]+)/*$') or ''
            else
                local okc, cwd = pcall(pane.get_current_working_dir, pane)
                if okc then
                    basename = cwd_basename(cwd)
                end
            end
        end
        pcall(window.set_right_status, window, basename ~= '' and ' ' .. basename .. ' ' or '')
    end)
end

return M
