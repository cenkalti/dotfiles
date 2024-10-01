-- Distraction-free writing
return {
    'folke/zen-mode.nvim',
    dependencies = {
        { 'folke/which-key.nvim' },
    },
    config = function()
        require('zen-mode').setup({
            plugins = {
                wezterm = {
                    enabled = true,
                    font = '+4',
                },
            },
        })
        require('which-key').add({
            { '<leader>z', '<cmd>ZenMode<CR>', desc = 'Zen Mode' },
        })
    end,
}
