-- Format code on save
return {
    'mhartington/formatter.nvim',
    config = function()
        -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
        require('formatter').setup({
            -- All formatter configurations are opt-in
            filetype = {
                html = { require('formatter.filetypes.javascript').prettier },
                javascript = { require('formatter.filetypes.javascript').prettier },
                javascriptreact = { require('formatter.filetypes.javascript').prettier },
                lua = { require('formatter.filetypes.lua').stylua },
                go = {
                    function()
                        local util = require('formatter.util')
                        return {
                            exe = 'gci',
                            stdin = true,
                            args = {
                                'print',
                                '--section',
                                'standard',
                                '--section',
                                'default',
                                '--section',
                                '"prefix(github.com/gravitational/teleport)"',
                            },
                        }
                    end,
                    require('formatter.filetypes.go').goimports,
                },
                python = {
                    require('formatter.filetypes.python').isort,
                    require('formatter.filetypes.python').black,
                },
            },
        })

        vim.api.nvim_create_augroup('__formatter__', { clear = true })
        vim.api.nvim_create_autocmd('BufWritePost', {
            group = '__formatter__',
            command = ':FormatWrite',
        })
    end,
}
