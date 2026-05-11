-- Continue the comment leader when pressing <CR> in insert mode (r) and o/O
-- in normal mode (o). Filetype plugins (e.g. ftplugin/go.vim) set their own
-- formatoptions per-buffer on every FileType event, which would clobber a
-- plain `vim.opt.formatoptions` set in options.lua. Registering our own
-- FileType autocmd from after/plugin/ ensures it runs after all ftplugins
-- have loaded and fires after theirs, so our flags win in every buffer.
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        vim.opt_local.formatoptions:append('r')
        vim.opt_local.formatoptions:append('o')
    end,
})
