-- vim:foldmethod=marker:foldlevel=0

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
    command = 'setfiletype json',
})
-- }}}

-- {{{ Treat .mdx files as Markdown
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.mdx',
    command = 'setfiletype markdown',
})
-- }}}

-- {{{ Use jq to format JSON
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'json', 'jsonl' },
    callback = function()
        vim.opt_local.formatprg = 'jq'
        vim.opt_local.filetype = 'json'
    end,
})
-- }}}

-- {{{ Highlight trailing whitespace in red
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg = '#ff0000' })
local function set_trailing_ws(pattern)
    if vim.bo.buftype ~= '' then return end
    if vim.w.trailing_ws_id then
        pcall(vim.fn.matchdelete, vim.w.trailing_ws_id)
    end
    vim.w.trailing_ws_id = vim.fn.matchadd('TrailingWhitespace', pattern)
end
vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function() set_trailing_ws([[\s\+\%#\@<!$]]) end,
})
vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWinEnter' }, {
    callback = function() set_trailing_ws([[\s\+$]]) end,
})
-- }}}

-- {{{ Highlight rules for todo edit buffers
vim.api.nvim_set_hl(0, 'TodoActive', { fg = '#e5c07b', bold = true })
vim.api.nvim_set_hl(0, 'TodoCancelled', { fg = '#e06c75', bold = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = vim.fn.expand('~') .. '/.work/todos/edit-*.md',
    callback = function()
        vim.fn.matchadd('NonText', [[^\s*@ .*$]])
        vim.fn.matchadd('NonText', [[^\s*& .*$]])
        vim.fn.matchadd('NonText', [[<!--[a-z0-9]\{6}-->]])
        vim.fn.matchadd('TodoActive', '\\[/\\]')
        vim.fn.matchadd('TodoCancelled', '\\[-\\]')
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
