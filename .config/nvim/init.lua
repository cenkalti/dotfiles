-- Must set these before loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load plugin manager
require('config.lazy')

-- Set global options
require('config.options')

-- Load diagnostic configuration
require('config.diagnostic')

-- Load custom commands
require('config.user_commands')
require('config.auto_commands')

-- Load and setup the command line formatter
local format_command_line = require('format-command-line')
format_command_line.setup()
