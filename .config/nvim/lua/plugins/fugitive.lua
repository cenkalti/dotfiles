-- Git commands
return {
    'tpope/vim-fugitive',
    dependencies = {
        -- Enables :GBrowse from vim-fugitive to open GitHub URLs
        'tpope/vim-rhubarb',

        'folke/which-key.nvim',
    },
    config = function()
        require('which-key').add({
            { '<localleader>g', ':GBrowse<CR>', desc = 'View HTTP Link', mode = { 'n', 'v' } },
        })
    end,
}
