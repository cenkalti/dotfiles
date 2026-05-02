local wezterm = require('wezterm')

local M = {}

function M.setup(config)
    config.launch_menu = {}
    local workspace_dirs = { wezterm.home_dir .. '/projects', wezterm.home_dir .. '/.config' }
    for _, workspace_dir in ipairs(workspace_dirs) do
        for _, entry in ipairs(wezterm.read_dir(workspace_dir)) do
            local basename = entry:match('([^/]+)$')
            if basename and not basename:match('^%.') then
                table.insert(config.launch_menu, {
                    label = basename,
                    args = {
                        '/opt/homebrew/bin/zsh',
                        '-lic',
                        'exec /opt/homebrew/bin/nvim -c "Telescope find_files"',
                    },
                    cwd = entry,
                })
            end
        end
    end
end

return M
