local wezterm = require('wezterm')

local M = {}

function M.setup()
    -- Use hyperlinks directly in the terminal
    wezterm.on('open-uri', function(window, pane, uri)
        wezterm.log_info('open-uri fired: ' .. tostring(uri))
        local editor = '/opt/homebrew/bin/nvim'

        -- `agent inbox` emits agent-jump://<project>[/<branch>] hyperlinks; delegate to `agent jump` to focus the pane.
        local jump_id = uri:match('^agent%-jump://(.+)$')
        if jump_id then
            local agent_bin = wezterm.home_dir .. '/go/bin/agent'
            local ok, _, stderr = wezterm.run_child_process({ agent_bin, 'jump', jump_id })
            if not ok then
                wezterm.log_error('agent jump ' .. jump_id .. ' failed: ' .. (stderr or ''))
            end
            return false
        end

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

        if uri:find('^file:') == 1 then
            local url = wezterm.url.parse(uri)
            local foreground = pane:get_foreground_process_name()
            local in_shell = not pane:is_alt_screen_active() and is_shell(foreground)

            -- Foreground is a TUI or non-shell process (claude, nvim, less, etc): open nvim in a new tab.
            if not in_shell then
                local args = { editor }
                if url.fragment then
                    table.insert(args, '+' .. url.fragment)
                end
                table.insert(args, url.file_path)
                window:mux_window():spawn_tab({ args = args })
                return false
            end

            do
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
                            pane:send_text(
                                wezterm.shell_join_args({ editor, '+' .. url.fragment, url.file_path }) .. '\r'
                            )
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
end

return M