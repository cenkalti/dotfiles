return {
    'folke/paint.nvim',
    config = function()
        require('paint').setup({
            highlights = {
                {
                    filter = { filetype = 'python' },
                    pattern = '^%s*assert%s+.*$',
                    hl = 'Comment',
                },
            },
        })
    end,
}
