return {
    'gbprod/yanky.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'folke/which-key.nvim',
    },
    config = function()
        require('yanky').setup()
        require('telescope').load_extension('yank_history')
        require('which-key').register({
            ['<Leader>p'] = { require('telescope').extensions.yank_history.yank_history, 'Yank History' },
        })
    end,
}
