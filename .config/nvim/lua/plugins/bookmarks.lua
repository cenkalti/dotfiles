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

        vim.keymap.set('n', 'mm', function()
            bookmarks.toggle_bookmark({ with_comment = false })
        end, { desc = 'Toggle bookmark' })
        vim.keymap.set('n', 'mc', bookmarks.modify_comment, { desc = 'Modify bookmark comment' })
        vim.keymap.set('n', 'ms', bookmarks.show_comment, { desc = 'Show bookmark comment' })
        vim.keymap.set('n', 'ml', '<cmd>Telescope lspmark<cr>', { desc = 'List bookmarks' })
        vim.keymap.set('n', 'dd', bookmarks.delete_line, { desc = 'Delete line (bookmark-aware)' })
        vim.keymap.set('x', 'd', bookmarks.delete_visual_selection, { desc = 'Delete selection (bookmark-aware)' })
        vim.keymap.set('n', 'p', bookmarks.paste_text, { desc = 'Paste (bookmark-aware)' })

        -- Load bookmarks on startup and when changing directories
        bookmarks.load_bookmarks()
        vim.api.nvim_create_autocmd({ 'DirChanged' }, {
            callback = bookmarks.load_bookmarks,
            pattern = { '*' },
        })
    end,
}
