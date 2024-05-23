return {
    -- https://github.com/nordtheme/vim/issues/353#issuecomment-2120726820
    'ericvw/nordtheme-vim',
    branch = 'pu',

    -- 'nordtheme/vim'
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        vim.o.termguicolors = true
        vim.cmd([[colorscheme nord]])
    end,
}
