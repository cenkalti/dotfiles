-- Must set these before loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Load plugin manager
require('config.lazy')

-- Set global options
require('config.options')

-- Load custom commands
require('config.user_commands')
require('config.auto_commands')
