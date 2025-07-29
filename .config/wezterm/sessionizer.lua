local wezterm = require('wezterm')

local M = {}

local sessionizer = wezterm.plugin.require('https://github.com/mikkasendke/sessionizer.wezterm')

local my_schema = {
    sessionizer.FdSearch({
        wezterm.home_dir .. '/projects',
        fd_path = '/opt/homebrew/bin/fd',
        max_depth = 2,
    }),
}

function M.setup(config)
    table.insert(config.keys, { key = 'e', mods = 'SUPER', action = sessionizer.show(my_schema) })
end

return M