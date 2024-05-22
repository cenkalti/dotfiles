-- Format code on save
return {
    'mhartington/formatter.nvim',
    config = function()
        -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
        require('formatter').setup({
            -- All formatter configurations are opt-in
            filetype = {
                lua = { require('formatter.filetypes.lua').stylua },
                go = { require('formatter.filetypes.go').goimports },
            },
        })

        local augroup = vim.api.nvim_create_augroup
        local autocmd = vim.api.nvim_create_autocmd
        augroup('__formatter__', { clear = true })
        autocmd('BufWritePost', {
            group = '__formatter__',
            command = ':FormatWrite',
        })
    end,
}
