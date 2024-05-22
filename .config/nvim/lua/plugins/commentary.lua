-- Comment out code
return {
    'tpope/vim-commentary',
    dependencies = {
        'folke/which-key.nvim',
    },
    config = function()
        require('which-key').register({
            ['<LocalLeader><CR>'] = { 'yypk:Commentary<CR>j', 'Duplicate & Comment' },
        }, { silent = true })
    end,
}
