return {
    'nordtheme/vim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        vim.o.termguicolors = true
        vim.cmd([[colorscheme nord]])
    end,
}
