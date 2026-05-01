local wezterm = require('wezterm')

local M = {}

-- toggle activates the first tab in the current window whose active pane is
-- running the program (matched by basename). If no such tab exists, spawns a
-- new tab in the current pane's cwd and runs `program` there.
--
-- `program` must be an absolute path; WezTerm GUI on macOS doesn't inherit
-- the login shell PATH, so /opt/homebrew/bin et al. are not searched.
local function toggle(window, pane, program)
    local mux_window = window:mux_window()
    if not mux_window then
        return
    end

    local target_basename = program:match('([^/]+)$') or program

    for _, tab in ipairs(mux_window:tabs()) do
        for _, p in ipairs(tab:panes()) do
            local fg = p:get_foreground_process_name() or ''
            local basename = fg:match('([^/]+)$') or fg
            if basename == target_basename then
                tab:activate()
                return
            end
        end
    end

    local cwd = pane:get_current_working_dir()
    local cwd_path = cwd and cwd.file_path or nil
    mux_window:spawn_tab({ args = { program }, cwd = cwd_path })
end

function M.setup()
    wezterm.on('toggle-lazygit', function(window, pane)
        toggle(window, pane, '/opt/homebrew/bin/lazygit')
    end)
    wezterm.on('toggle-nvim', function(window, pane)
        toggle(window, pane, '/opt/homebrew/bin/nvim')
    end)
end

return M
