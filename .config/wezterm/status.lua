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
    -- Window title: which agent. It is the name macOS shows in cmd-tab and
    -- Mission Control, so it has to be the one value that distinguishes agents,
    -- and the cwd basename is not: every agent in a repo shares it, and a
    -- remote agent has no local cwd at all. Falls back to the cwd basename for
    -- ordinary panes, then to the pane title.
    wezterm.on('format-window-title', function(tab, pane)
        local handle = agent_handle(pane)
        if handle ~= '' then
            return handle
        end
        local basename = cwd_basename(pane.current_working_dir)
        return basename ~= '' and basename or tab.active_pane.title
    end)

    wezterm.on('update-status', function(window, pane)
        -- Left status: the agent's handle from the work_handle user var, else
        -- the workspace name, with WezTerm's unnamed 'default' suppressed. The
        -- two normally agree, since a workspace is named after the agent it
        -- holds; the var wins because it comes from the record, so a workspace
        -- renamed by hand cannot rename the agent on the bar.
        --
        -- Every mux read below is pcall-guarded (same reasoning work.lua's own
        -- update-status handler documents): when the mux domain channel drops,
        -- get_user_vars and active_workspace raise, and an unguarded raise would
        -- abort this handler before set_left_status runs — freezing the bar at
        -- its last value until the channel recovers. Guarding lets a bad tick
        -- fall through to empty and the next healthy tick repaint.
        local left = ''
        if pane then
            local ok, vars = pcall(pane.get_user_vars, pane)
            if ok and vars and vars.work_handle and vars.work_handle ~= '' then
                left = vars.work_handle
            end
        end
        if left == '' then
            local ok, ws = pcall(window.active_workspace, window)
            if ok and ws and ws ~= 'default' then
                left = ws
            end
        end
        pcall(window.set_left_status, window, left ~= '' and ' ' .. left .. ' ' or '')

        local basename = ''
        if pane then
            local ok, cwd = pcall(pane.get_current_working_dir, pane)
            if ok then
                basename = cwd_basename(cwd)
            end
        end
        pcall(window.set_right_status, window, basename ~= '' and ' ' .. basename .. ' ' or '')
    end)
end

return M
