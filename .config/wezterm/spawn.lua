local wezterm = require('wezterm')

local M = {}

-- Wraps a command (string or list) so it's launched via `zsh -c 'exec ...'`.
-- This ensures .zshenv runs and PATH is populated; otherwise programs spawned
-- by WezTerm's GUI on macOS inherit a sparse environment and can't find tools
-- in /opt/homebrew/bin etc.
function M.wrap(cmd)
    local cmd_str = type(cmd) == 'table' and wezterm.shell_join_args(cmd) or cmd
    return { '/opt/homebrew/bin/zsh', '-c', 'exec ' .. cmd_str }
end

return M
