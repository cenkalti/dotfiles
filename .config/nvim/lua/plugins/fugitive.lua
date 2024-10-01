-- Git commands
return {
    'tpope/vim-fugitive',
    dependencies = {
        'folke/which-key.nvim',
    },
    config = function()
        local wk = require('which-key')

        wk.add({
            { '<leader>gs', '<cmd>Git<CR>', desc = 'View Git Status' },
            { 'gb', '<cmd>GBrowse<CR>', desc = 'View HTTP Link' },
        })

        wk.add({
            { 'gb', '<cmd>GBrowse<CR>', desc = 'View HTTP Link', mode = 'v' },
        })
    end,
}
