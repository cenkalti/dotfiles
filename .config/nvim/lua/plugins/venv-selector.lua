return {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
        { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
        { 'folke/which-key.nvim' },
    },
    lazy = false,
    branch = 'regexp', -- This is the regexp branch, use this for the new version
    config = function()
        require('venv-selector').setup()
        require('which-key').add({
            { '<Leader>v', '<cmd>VenvSelect<cr>', desc = 'Select Virtualenv' },
        })
    end,
}
