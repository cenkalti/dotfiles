local wezterm = require('wezterm')

local M = {}

function M.setup(config)
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
end

return M