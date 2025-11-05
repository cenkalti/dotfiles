-- Outline sidebar
return {
    'hedyhli/outline.nvim',
    config = function()
        require('outline').setup({})
        require('which-key').add({
            { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle Outline' },
        })
    end,
}
