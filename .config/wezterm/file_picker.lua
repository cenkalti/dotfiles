local wezterm = require('wezterm')
local spawn = require('spawn')

local M = {}

local function detect_root(pane)
    local cwd_uri = pane:get_current_working_dir()
    local cwd = cwd_uri and cwd_uri.file_path
    if not cwd or cwd == '' then
        return nil
    end
    cwd = cwd:gsub('/$', '')
    local ws = cwd .. '/workspace'
    local ok = wezterm.run_child_process({ 'test', '-L', ws })
    if ok then
        return ws
    end
    return cwd
end

local function list_files(root, extra_args)
    local cmd = {
        '/opt/homebrew/bin/fd',
        '--type', 'f',
        '--hidden',
        '--exclude', '.git',
        '--base-directory', root,
    }
    for _, arg in ipairs(extra_args or {}) do
        table.insert(cmd, arg)
    end
    table.insert(cmd, '.')
    local ok, stdout = wezterm.run_child_process(cmd)
    if not ok then
        return {}
    end
    local files = {}
    for line in stdout:gmatch('[^\r\n]+') do
        if not line:match('^archive/') and not line:match('^ideas/') then
            table.insert(files, line)
        end
    end
    return files
end

-- open_file hands the file to open-in-nvim, naming the pane we are acting for.
--
-- This used to work the editor out here, two ways and both window-scoped: build
-- ~/.work/run/nvim-wez-<window_id>.sock, and scan the window's tabs for one with
-- a pane whose foreground process is nvim. Each assumed one editor per WezTerm
-- window, which stopped being true when agents became tabs — a window holds
-- several, so the socket named the window's *first* editor and the scan returned
-- whichever tab happened to be showing nvim. Picking a file in one agent's tab
-- dropped it in a neighbour's.
--
-- The script resolves it from the pane's own tmux session instead, and it is the
-- same script lazygit's `o` runs, so "which editor serves this pane" has one
-- answer rather than two that can disagree. It also handles the no-editor-yet
-- case (it creates the tool window through `agent tool-argv`), which is why the
-- spawn_tab fallback is gone from here.
local function open_file(_, pane, root, rel_path)
    if not pane then
        return
    end
    wezterm.run_child_process({
        wezterm.home_dir .. '/.local/bin/open-in-nvim',
        '--wez-pane', tostring(pane:pane_id()),
        root .. '/' .. rel_path,
    })
end

local function pick_file(window, pane, opts)
    local root = detect_root(pane)
    if not root then
        return
    end
    local files = list_files(root, opts.fd_args)
    if #files == 0 then
        return
    end
    local choices = {}
    for _, rel in ipairs(files) do
        table.insert(choices, { label = rel, id = rel })
    end
    window:perform_action(
        wezterm.action.InputSelector({
            title = opts.title,
            choices = choices,
            fuzzy = true,
            action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
                if id and id ~= '' then
                    opts.on_select(inner_window, inner_pane, root, id)
                end
            end),
        }),
        pane
    )
end

local function glow_file(window, root, rel_path)
    local abs = root .. '/' .. rel_path
    local mux = window:mux_window()
    if mux then
        mux:spawn_tab({
            args = spawn.wrap({ 'glow', '-p', abs }),
            cwd = root,
        })
    end
end

function M.setup()
    wezterm.on('file-picker-workspace', function(window, pane)
        pick_file(window, pane, {
            title = 'Files',
            on_select = open_file,
        })
    end)

    wezterm.on('file-picker-glow', function(window, pane)
        pick_file(window, pane, {
            title = 'Markdown',
            fd_args = { '--extension', 'md', '--extension', 'markdown' },
            on_select = function(w, _, root, id) glow_file(w, root, id) end,
        })
    end)
end

return M
