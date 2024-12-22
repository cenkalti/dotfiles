-- Status line
return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    globalstatus = true,
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '|', right = '|' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { 'searchcount' },
                },
            })
        end,
    },
}
