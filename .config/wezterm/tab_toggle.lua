local wezterm = require('wezterm')
local spawn = require('spawn')
local work = require('work')

local M = {}

-- Tab slots, shared with work.lua's ⌘A: the agent is tab 1, lazygit tab 2,
-- nvim tab 3 (0-based here, as MoveTab counts). Every press lands the tab in
-- its slot, whether it was just spawned or already open, so the layout holds.
local LAZYGIT_TAB = 1
local NVIM_TAB = 2

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
-- running a process matching `target_basename`, or spawns one in the current
-- pane's cwd with `spawn_args` when there is none. Either way the tab ends up
-- pinned at tab_index.
local function toggle(window, pane, target_basename, spawn_args, tab_index)
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
                work.pin_tab(window, pane, mux_window, tab_index)
                return
            end
        end
    end

    local tab = mux_window:spawn_tab({ args = spawn_args, cwd = current_cwd(pane) })
    tab:activate()
    work.pin_tab(window, pane, mux_window, tab_index)
end

function M.setup()
    wezterm.on('toggle-lazygit', function(window, pane)
        toggle(window, pane, 'lazygit', spawn.wrap('/opt/homebrew/bin/lazygit'), LAZYGIT_TAB)
    end)
    wezterm.on('toggle-nvim', function(window, pane)
        toggle(window, pane, 'nvim', spawn.wrap('nvim'), NVIM_TAB)
    end)
end

return M
