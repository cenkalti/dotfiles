-- Comment out code
return {
    'tpope/vim-commentary',
    dependencies = {
        'folke/which-key.nvim',
    },
    config = function()
        require('which-key').add({
            { '<LocalLeader><CR>', 'yypk:Commentary<CR>j', desc = 'Duplicate & Comment' },
        }, { silent = true })
    end,
}
