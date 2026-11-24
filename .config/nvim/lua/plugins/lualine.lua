-- Configurable status line
local function number_of_lines()
    return vim.fn.line('$')
end

-- Line-count bands for the bottom-right component, so a long file reads from
-- the colour alone. File sizes are log-normal, so the cut points are the mean
-- plus one and two standard deviations of log10(lines), measured over the
-- source files in teleport and core (Nov 2026): 406 and 1222, rounded. Below
-- the first the component keeps the theme's mode colour; the bands hold about
-- 85%, 12% and 2.5% of files.
local line_bands = {
    { min = 1200, color = 'red' },
    { min = 400, color = 'yellow' },
}

local function number_of_lines_color()
    local lines = vim.fn.line('$')
    for _, band in ipairs(line_bands) do
        if lines >= band.min then
            local palette = require('catppuccin.palettes').get_palette()
            return { fg = palette.crust, bg = palette[band.color], gui = 'bold' }
        end
    end
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
                    lualine_b = { 'branch' },
                    lualine_c = { { 'filename', path = 1 } },
                    lualine_x = {},
                    lualine_y = { 'diff' },
                    lualine_z = { { number_of_lines, color = number_of_lines_color } },
                },
            })
        end,
    },
}
