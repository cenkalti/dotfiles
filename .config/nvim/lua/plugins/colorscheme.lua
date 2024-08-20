return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
        require('catppuccin').setup({
            flavour = 'macchiato',
            transparent_background = true,
            dim_inactive = {
                enabled = true,
                shade = 'dark',
                percentage = 0.15,
            },
        })
        vim.cmd.colorscheme('catppuccin')
    end,
}
