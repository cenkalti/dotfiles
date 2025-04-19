-- Status line
local function number_of_lines()
    return vim.fn.line('$')
end
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
                    lualine_x = { 'searchcount' },
                    lualine_y = { 'diff' },
                    lualine_z = { number_of_lines },
                },
            })
        end,
    },
}
