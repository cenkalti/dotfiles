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
        require('which-key').register({
            ['<leader>z'] = { '<cmd>ZenMode<CR>', 'Zen Mode' },
        })
    end,
}
