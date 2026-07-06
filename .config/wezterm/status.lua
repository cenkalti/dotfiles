local wezterm = require('wezterm')

local M = {}

local function cwd_basename(cwd_uri)
    local cwd = cwd_uri and cwd_uri.file_path or ''
    return cwd:match('([^/]+)/*$') or ''
end

function M.setup()
    wezterm.on('format-window-title', function(tab, pane)
        local basename = cwd_basename(pane.current_working_dir)
        return basename ~= '' and basename or tab.active_pane.title
    end)

    wezterm.on('update-status', function(window, pane)
        -- Left status: the agent's display handle (work_handle user var, set by
        -- the work harness) when present, else the workspace name — with
        -- WezTerm's unnamed 'default' suppressed. The harness now names an
        -- agent's workspace after its handle too, so the two agree for agent
        -- panes; work_handle stays the preferred source as the authoritative
        -- per-pane identity (covers in-place runs and panes moved workspaces).
        --
        -- Every mux read below is pcall-guarded (same reasoning work.lua's own
        -- update-status handler documents): when the mux domain channel drops,
        -- get_user_vars / active_workspace raise, and an unguarded raise would
        -- abort this handler before set_left_status runs — freezing the bar at
        -- its last value until the channel recovers. Guarding lets a bad tick
        -- fall through to empty and the next healthy tick repaint.
        local left = ''
        if pane then
            local ok, vars = pcall(pane.get_user_vars, pane)
            if ok and vars then
                left = vars.work_handle or ''
            end
        end
        if left == '' then
            local ok, ws = pcall(window.active_workspace, window)
            if ok and ws then
                left = ws
            end
        end
        if left == 'default' then
            left = ''
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
