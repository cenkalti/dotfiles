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
        local workspace = window:active_workspace()
        window:set_left_status(workspace ~= 'default' and ' ' .. workspace .. ' ' or '')

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
