-- vim:foldmethod=marker:foldlevel=0

-- {{{ Write all buffers on focus lost
vim.api.nvim_create_autocmd('FocusLost', {
    pattern = '*',
    command = 'wa',
})
-- }}}

-- {{{ Hide quickfix buffer from buffer list
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        vim.opt_local.buflisted = false
    end,
})
-- }}}

-- {{{ Auto-resize quickfix window
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        local minheight, maxheight = 3, 10
        local height = math.max(math.min(vim.fn.line('$'), maxheight), minheight)
        vim.cmd(height .. 'wincmd _')
    end,
})
-- }}}

-- {{{ Treat .jsonl files as JSON
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.jsonl',
    command = 'setf json',
})
-- }}}

-- {{{ Use jq to format JSON
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*.json',
    callback = function()
        vim.opt_local.formatprg = 'jq'
    end,
})
-- }}}

-- {{{ Disable line wrapping in quickfix and location lists
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'qf', 'loclist' },
    callback = function()
        vim.opt_local.wrap = false
    end,
})
-- }}}
