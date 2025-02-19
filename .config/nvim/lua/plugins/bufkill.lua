-- Delete buffer without changing window layout
return {
    'qpkorr/vim-bufkill',
    dependencies = {
        'folke/which-key.nvim',
    },
    init = function()
        vim.g.BufKillCreateMappings = 0
        vim.g.BufKillActionWhenBufferDisplayedInAnotherWindow = 'kill'
    end,
    config = function()
        require('which-key').add({
            { '<leader>d', '<cmd>BW<CR>', desc = 'Wipe Buffer' },
        })
    end,
}
