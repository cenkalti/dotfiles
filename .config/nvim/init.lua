-- Load legacy vim config
vim.cmd('source ~/.vimrc')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require('lazy').setup('plugins', {
    change_detection = {
        enable = false,
        notify = false,
    },
    checker = {
        enabled = true,
        frequency = 7 * 24 * 3600,
    },
})
