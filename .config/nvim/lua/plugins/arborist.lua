-- Tree-sitter parser manager
return {
    'arborist-ts/arborist.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('arborist').setup({
            install_popular = false,
            ensure_installed = {
                'lua',
                'vim',
                'vimdoc',
                'comment',
                'python',
                'go',
                'javascript',
                'typescript',
                'markdown',
                'markdown_inline',
            },
        })
    end,
}
