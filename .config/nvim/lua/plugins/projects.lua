return {
    'ahmedkhalf/project.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'folke/which-key.nvim',
    },
    config = function()
        require('project_nvim').setup({
            detection_methods = { 'lsp', 'pattern' },
            patterns = { '.git', 'Makefile', 'package.json', '.luarc.json' },
            show_hidden = true,
            scope_chdir = 'tab',
            datapath = vim.fn.stdpath('data'),
        })
        require('telescope').load_extension('projects')
        require('which-key').register(
            { w = {
                function()
                    require('telescope').extensions.projects.projects({})
                end,
                'Switch workspace',
            } },
            { prefix = '\\' }
        )
    end,
}
