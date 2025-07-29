-- Pull in the wezterm API
---@type Wezterm
local wezterm = require('wezterm')

local resurrect = wezterm.plugin.require('https://github.com/MLFlexer/resurrect.wezterm')
resurrect.state_manager.set_max_nlines(5000)

-- This will hold the configuration.
---@class Config
local config = wezterm.config_builder()

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.color_scheme = 'Catppuccin Macchiato'
config.font_size = 15.0
config.quit_when_all_windows_are_closed = false
config.default_prog = { '/opt/homebrew/bin/zsh', '-li' }
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 120
config.initial_rows = 36
config.scrollback_lines = 100000
config.enable_scroll_bar = true
config.macos_window_background_blur = 10
config.window_decorations = 'RESIZE'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.warn_about_missing_glyphs = false
config.window_content_alignment = {
    horizontal = 'Left',
    vertical = 'Top',
}
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Read ~/projects dir and add each dir to launch menu
config.launch_menu = {}
local workspace_dirs = { '~/projects', '~/.config' }
for _, workspace_dir in ipairs(workspace_dirs) do
    local handle = io.popen('ls -1 ' .. workspace_dir)
    if handle then
        for project_dir in handle:lines() do
            table.insert(config.launch_menu, {
                label = project_dir,
                args = {
                    '/opt/homebrew/bin/zsh',
                    '-lic',
                    'cd '
                        .. workspace_dir
                        .. '/'
                        .. project_dir
                        .. ' && exec /opt/homebrew/bin/nvim -c "Telescope find_files"',
                },
            })
        end
        handle:close()
    end
end

local default_windows_background_opacity = 0.90
local default_text_background_opacity = 0.5
config.window_background_opacity = default_windows_background_opacity
config.text_background_opacity = default_text_background_opacity
local transparency_enabled = true
wezterm.on('toggle-transparency', function(window, _)
    if transparency_enabled then
        transparency_enabled = false
        window:set_config_overrides({
            window_background_opacity = 1.0,
            text_background_opacity = 1.0,
        })
    else
        transparency_enabled = true
        window:set_config_overrides({
            window_background_opacity = default_windows_background_opacity,
            text_background_opacity = default_text_background_opacity,
        })
    end
end)

config.keys = {
    {
        key = 'l',
        mods = 'SUPER',
        action = wezterm.action.ShowLauncherArgs({ title = 'Projects', flags = 'FUZZY|LAUNCH_MENU_ITEMS' }),
    },
    { key = '{', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative(-1) },
    { key = '}', mods = 'SHIFT|ALT', action = wezterm.action.MoveTabRelative(1) },
    {
        key = 'k',
        mods = 'SUPER',
        action = wezterm.action.Multiple({
            wezterm.action.SendKey({ key = 'C', mods = 'CTRL' }),
            wezterm.action.SendKey({ key = 'L', mods = 'CTRL' }),
            wezterm.action.ClearScrollback('ScrollbackAndViewport'),
        }),
    },
    { key = 't', mods = 'SUPER|ALT', action = wezterm.action.EmitEvent('toggle-transparency') },

    -- Workspace Switcher
    {
        key = 's',
        mods = 'SUPER',
        action = wezterm.action.ShowLauncherArgs({ title = 'Workspaces', flags = 'WORKSPACES' }),
    },
    {
        key = ']',
        mods = 'SUPER',
        action = wezterm.action.SwitchWorkspaceRelative(1),
    },
    {
        key = '[',
        mods = 'SUPER',
        action = wezterm.action.SwitchWorkspaceRelative(-1),
    },

    -- New Workspace
    {
        key = 'S',
        mods = 'SUPER',
        action = wezterm.action.PromptInputLine({
            description = wezterm.format({
                { Attribute = { Intensity = 'Bold' } },
                { Foreground = { AnsiColor = 'Fuchsia' } },
                { Text = 'Enter name for new workspace' },
            }),
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    ---@diagnostic disable-next-line: param-type-mismatch
                    window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
                end
            end),
        }),
    },

    -- Save Workspace State
    {
        key = 's',
        mods = 'LEADER',
        ---@diagnostic disable-next-line: assign-type-mismatch
        action = wezterm.action_callback(function(win, pane)
            resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
        end),
    },
    -- Restore Workspace State
    {
        key = 'r',
        mods = 'LEADER',
        ---@diagnostic disable-next-line: assign-type-mismatch
        action = wezterm.action_callback(function(win, pane)
            --- @diagnostic disable-next-line: unused-local
            resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
                local type = string.match(id, '^([^/]+)') -- match before '/'
                id = string.match(id, '([^/]+)$') -- match after '/'
                id = string.match(id, '(.+)%..+$') -- remove file extention
                local opts = {
                    relative = true,
                    restore_text = true,
                    on_pane_restore = resurrect.tab_state.default_on_pane_restore,
                }
                if type == 'workspace' then
                    local state = resurrect.state_manager.load_state(id, 'workspace')
                    resurrect.workspace_state.restore_workspace(state, opts)
                elseif type == 'window' then
                    local state = resurrect.state_manager.load_state(id, 'window')
                    resurrect.window_state.restore_window(pane:window(), state, opts)
                elseif type == 'tab' then
                    local state = resurrect.state_manager.load_state(id, 'tab')
                    resurrect.tab_state.restore_tab(pane:tab(), state, opts)
                end
            end)
        end),
    },
    -- Delete Workspace State
    {
        key = 'd',
        mods = 'LEADER',
        ---@diagnostic disable-next-line: assign-type-mismatch
        action = wezterm.action_callback(function(win, pane)
            resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
                resurrect.state_manager.delete_state(id)
            end, {
                title = 'Delete State',
                description = 'Select State to Delete and press Enter = accept, Esc = cancel, / = filter',
                fuzzy_description = 'Search State to Delete: ',
                is_fuzzy = true,
            })
        end),
    },
}

-- Use hyperlinks directly in the terminal
wezterm.on('open-uri', function(_, pane, uri)
    local editor = 'nvim'

    local function is_shell(foreground_process_name)
        local shell_names = { 'bash', 'zsh', 'sh' }
        local process = string.match(foreground_process_name, '[^/\\]+$') or foreground_process_name
        for _, shell in ipairs(shell_names) do
            if process == shell then
                return true
            end
        end
        return false
    end

    if uri:find('^file:') == 1 and not pane:is_alt_screen_active() then
        -- We're processing an hyperlink and the uri format should be: file://[HOSTNAME]/PATH[#linenr]
        -- Also the pane is not in an alternate screen (an editor, less, etc)
        local url = wezterm.url.parse(uri)
        if is_shell(pane:get_foreground_process_name()) then
            -- A shell has been detected. Wezterm can check the file type directly
            -- figure out what kind of file we're dealing with
            local success, stdout, _ = wezterm.run_child_process({
                'file',
                '--brief',
                '--mime-type',
                url.file_path,
            })
            if success then
                if stdout:find('directory') then
                    pane:send_text(wezterm.shell_join_args({ 'cd', url.file_path }) .. '\r')
                    pane:send_text(wezterm.shell_join_args({ 'l' }) .. '\r')
                    return false
                end

                if stdout:find('text') then
                    if url.fragment then
                        pane:send_text(wezterm.shell_join_args({ editor, '+' .. url.fragment, url.file_path }) .. '\r')
                    else
                        pane:send_text(wezterm.shell_join_args({ editor, url.file_path }) .. '\r')
                    end
                    return false
                end
            end
        end
    end
    -- without a return value, we allow default actions
end)

-- and finally, return the configuration to wezterm
return config
