return {
    'ahmedkhalf/project.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'folke/which-key.nvim',
    },
    config = function()
        require('project_nvim').setup({
            detection_methods = { 'pattern' },
            patterns = { '.git', '.luarc.json' },
            show_hidden = true,
            scope_chdir = 'tab',
            datapath = vim.fn.stdpath('data'),
        })
        require('telescope').load_extension('projects')
        require('which-key').add({
            {
                '\\w',
                function()
                    require('telescope').extensions.projects.projects({})
                end,
                desc = 'Switch workspace',
            },
        })
    end,
}
