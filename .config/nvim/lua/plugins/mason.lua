-- Package manager for LSP servers, linters and formatters
return {
    {
        'williamboman/mason.nvim',
        dependencies = {
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup() -- Automatically configures LSP servers
        end,
    },
}
