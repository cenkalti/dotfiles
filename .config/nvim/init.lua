-- Must set these before loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require('vim._core.ui2').enable({})

-- Load plugin manager
require('config.lazy')

-- Set global options
require('config.options')

-- Load diagnostic configuration
require('config.diagnostic')

-- Load custom commands
require('config.user_commands')
require('config.auto_commands')

-- Load custom highlights
require('field_receiver')
