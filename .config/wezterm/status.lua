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
        local left = pane and pane:get_user_vars().work_handle or ''
        if left == '' then
            left = window:active_workspace()
        end
        if left == 'default' then
            left = ''
        end
        window:set_left_status(left ~= '' and ' ' .. left .. ' ' or '')

        local basename = ''
        if pane then
            local ok, cwd = pcall(pane.get_current_working_dir, pane)
            if ok then
                basename = cwd_basename(cwd)
            end
        end
        window:set_right_status(basename ~= '' and ' ' .. basename .. ' ' or '')
    end)
end

return M
