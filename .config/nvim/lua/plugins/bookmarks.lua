-- LSP-based bookmarks (symbols survive refactoring)
return {
    'tristone13th/lspmark.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        require('lspmark').setup()
        require('telescope').load_extension('lspmark')

        local bookmarks = require('lspmark.bookmarks')

        vim.keymap.set('n', 'mm', bookmarks.toggle_bookmark, { desc = 'Toggle bookmark' })
        vim.keymap.set('n', 'mc', bookmarks.modify_comment, { desc = 'Modify bookmark comment' })
        vim.keymap.set('n', 'ms', bookmarks.show_comment, { desc = 'Show bookmark comment' })
        vim.keymap.set('n', 'ml', '<cmd>Telescope lspmark<cr>', { desc = 'List bookmarks' })

        -- Load bookmarks on startup and when changing directories
        bookmarks.load_bookmarks()
        vim.api.nvim_create_autocmd({ 'DirChanged' }, {
            callback = function()
                bookmarks.load_bookmarks(vim.fn.getcwd())
            end,
            pattern = { '*' },
        })
    end,
}
