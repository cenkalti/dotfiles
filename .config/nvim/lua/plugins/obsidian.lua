-- Obsidian note management
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
        ui = {
            enable = false,
        },
        workspaces = {
            {
                name = 'personal',
                path = '~/notes',
            },
        },
    },
}
