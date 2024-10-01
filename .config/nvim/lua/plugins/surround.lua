-- Change quotes with `cs'"`, delete with `ds"`.
return {
    'tpope/vim-surround',
    dependencies = {
        'folke/which-key.nvim',
    },
    config = function()
        require('which-key').add({
            { "<leader>'", '<cmd>normal cs"\'<CR>', desc = 'Toggle to Single Quotes' },
            { '<leader>"', '<cmd>normal cs\'"<CR>', desc = 'Toggle to Double Quotes' },
        })
    end,
}
