return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
        require('catppuccin').setup({
            flavour = 'macchiato',
            custom_highlights = function(colors)
                return {
                    Search = { bg = colors.red, fg = colors.mantle },
                    CurSearch = { bg = colors.rosewater, fg = colors.mantle },
                }
            end,
        })
        vim.cmd.colorscheme('catppuccin')
    end,
}
