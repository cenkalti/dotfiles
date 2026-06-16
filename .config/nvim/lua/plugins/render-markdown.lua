-- Render markdown in normal mode, raw while editing
return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons', 'folke/which-key.nvim' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    opts = {
        anti_conceal = { enabled = false },
    },
    config = function(_, opts)
        require('render-markdown').setup(opts)
        require('which-key').add({
            { '<leader>m', '<cmd>RenderMarkdown toggle<CR>', desc = 'Toggle Render Markdown' },
        })
    end,
}
