-- vim:foldmethod=marker:foldlevel=0

-- {{{ Convert tabs to spaces
vim.api.nvim_create_user_command('Tab2Space', function(opts)
    local ts = vim.opt.tabstop:get()
    local range = opts.range
    vim.cmd(string.format('%d,%ds#^\\t\\+#\\=repeat(" ", len(submatch(0))*%d)', range[1], range[2], ts))
end, { range = '%' })
-- }}}

-- {{{ Convert spaces to tabs
vim.api.nvim_create_user_command('Space2Tab', function(opts)
    local ts = vim.opt.tabstop:get()
    local range = opts.range
    vim.cmd(string.format('%d,%ds#^\\( \\{%d}\\)\\+#\\=repeat("\\t", len(submatch(0))/%d)', range[1], range[2], ts, ts))
end, { range = '%' })
-- }}}

-- {{{ Remove trailing whitespace
vim.api.nvim_create_user_command('TrimWhitespace', function()
    vim.cmd([[:%s/\s\+$//e]])
end, { range = '%' })
-- }}}
