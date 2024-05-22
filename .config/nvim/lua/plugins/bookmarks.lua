-- Custom bookmarks
return {
    'tomasky/bookmarks.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'folke/which-key.nvim',
    },
    config = function()
        local bookmarks = require('bookmarks')
        bookmarks.setup({
            sign_priority = 8, --set bookmark sign priority to cover git signs
            keywords = {
                ['@t'] = '☑️ ', -- mark annotation startswith @t ,signs this icon as `Todo`
                ['@w'] = '⚠️ ', -- mark annotation startswith @w ,signs this icon as `Warn`
                ['@f'] = '⛏ ', -- mark annotation startswith @f ,signs this icon as `Fix`
                ['@n'] = ' ', -- mark annotation startswith @n ,signs this icon as `Note`
            },
        })
        require('telescope').load_extension('bookmarks')
        require('which-key').register({
            ['mm'] = { bookmarks.bookmark_toggle, 'Toggle Bookmark' },
            ['mi'] = { bookmarks.bookmark_ann, 'Add or Edit Bookmark Annotation' },
            ['mc'] = { bookmarks.bookmark_clean, 'Clean Bookmarks in Local Buffer' },
            ['mn'] = { bookmarks.bookmark_next, 'Next Bookmark' },
            ['mp'] = { bookmarks.bookmark_prev, 'Previous Bookmark' },
            ['ml'] = { bookmarks.bookmark_list, 'List Bookmarks' },
            ['mL'] = { require('telescope').extensions.bookmarks.list, 'List Bookmarks in Telescope' },
        })
    end,
}
