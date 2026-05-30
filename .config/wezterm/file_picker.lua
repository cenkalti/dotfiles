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

local function list_files(root)
    local ok, stdout = wezterm.run_child_process({
        '/opt/homebrew/bin/fd',
        '--type', 'f',
        '--hidden',
        '--exclude', '.git',
        '--base-directory', root,
        '.',
    })
    if not ok then
        return {}
    end
    local files = {}
    for line in stdout:gmatch('[^\r\n]+') do
        table.insert(files, line)
    end
    return files
end

local function nvim_socket(window)
    local mux = window:mux_window()
    if not mux then
        return nil
    end
    return wezterm.home_dir .. '/.work/run/nvim-wez-' .. mux:window_id() .. '.sock'
end

local function find_nvim_tab(window)
    local mux_window = window:mux_window()
    if not mux_window then
        return nil
    end
    for _, tab in ipairs(mux_window:tabs()) do
        for _, p in ipairs(tab:panes()) do
            local fg = p:get_foreground_process_name() or ''
            local basename = fg:match('([^/]+)$') or fg
            if basename == 'nvim' then
                return tab
            end
        end
    end
    return nil
end

local function open_file(window, root, rel_path)
    local abs = root .. '/' .. rel_path
    local socket = nvim_socket(window)

    if socket and wezterm.run_child_process({ 'test', '-S', socket }) then
        local ok = wezterm.run_child_process({
            '/opt/homebrew/bin/nvim',
            '--server', socket,
            '--remote', abs,
        })
        if ok then
            local tab = find_nvim_tab(window)
            if tab then
                tab:activate()
            end
            return
        end
    end

    local mux = window:mux_window()
    if mux then
        mux:spawn_tab({
            args = spawn.wrap({ 'nvim', abs }),
            cwd = root,
        })
    end
end

function M.setup()
    wezterm.on('file-picker-workspace', function(window, pane)
        local root = detect_root(pane)
        if not root then
            return
        end
        local files = list_files(root)
        if #files == 0 then
            return
        end
        local choices = {}
        for _, rel in ipairs(files) do
            table.insert(choices, { label = rel, id = rel })
        end
        window:perform_action(
            wezterm.action.InputSelector({
                title = 'Files',
                choices = choices,
                fuzzy = true,
                action = wezterm.action_callback(function(inner_window, _, id, _)
                    if id and id ~= '' then
                        open_file(inner_window, root, id)
                    end
                end),
            }),
            pane
        )
    end)
end

return M
