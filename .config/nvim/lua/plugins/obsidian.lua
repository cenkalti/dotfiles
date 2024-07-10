return {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    dependencies = {
        -- Required.
        'nvim-lua/plenary.nvim',
        -- Optional.
        'hrsh7th/nvim-cmp',
        'nvim-telescope/telescope.nvim',
        'nvim-treesitter',
    },
    opts = {
        workspaces = {
            {
                name = 'work',
                path = '~/Documents/Obsidian Vaults/Atolio',
            },
        },
    },
    init = function()
        vim.opt.conceallevel = 1
    end,
}
