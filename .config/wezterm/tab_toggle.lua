local wezterm = require('wezterm')
local spawn = require('spawn')

local M = {}

-- current_cwd resolves the directory for a new tab. WezTerm's own OSC-7 cwd is
-- blind inside tmux, so for an agent pane (running `tmux attach`) it reads the
-- work_cwd user var that `agent attach-pane` tags on the pane; otherwise it
-- falls back to WezTerm's cwd (correct for plain shell panes).
local function current_cwd(pane)
    local vars = pane:get_user_vars()
    if vars and vars.work_cwd and vars.work_cwd ~= '' then
        return vars.work_cwd
    end
    local cwd = pane:get_current_working_dir()
    return cwd and cwd.file_path or nil
end

-- toggle activates the first tab in the current window whose active pane is
-- running a process matching `target_basename`. If none exists, spawns a new
-- tab in the current pane's cwd with `spawn_args`.
local function toggle(window, pane, target_basename, spawn_args)
    local mux_window = window:mux_window()
    if not mux_window then
        return
    end

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

    mux_window:spawn_tab({ args = spawn_args, cwd = current_cwd(pane) })
end

function M.setup()
    wezterm.on('toggle-lazygit', function(window, pane)
        toggle(window, pane, 'lazygit', spawn.wrap('/opt/homebrew/bin/lazygit'))
    end)
    wezterm.on('toggle-nvim', function(window, pane)
        toggle(window, pane, 'nvim', spawn.wrap('nvim'))
    end)
end

return M
