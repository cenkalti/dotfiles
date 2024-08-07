return {
    'folke/which-key.nvim',
    version = '2',
    event = 'VeryLazy',

    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,

    config = function()
        -- Set key mappings that does not require any plugin here.
        -- If it requires a plugin, put inside respective plugin lua file.
        local wk = require('which-key')

        -- Leader Key Bindings
        wk.register({
            D = { ':bd!<CR>', 'Close current buffer' },
            q = { ':%bd<CR>', 'Close all buffers' },
            Q = { ':qa!<CR>', 'Quit Neovim without saving' },
            w = { 'ciw', 'Change word under cursor' },
            W = { 'ciW', 'Change WORD under cursor' },
            s = { ":set hlsearch<CR>:let @/='\\<'..expand('<cword>')..'\\>'<CR>", 'Highlight word under cursor' },
            c = { ':cclose<CR>', 'Close quickfix list' },
            y = { '"+y', 'Copy to clipboard' },
            Y = { '"+yg_', 'Copy to end of line to clipboard' },
            p = { '"+p', 'Paste from clipboard' },
            P = { '"+P', 'Paste before cursor from clipboard' },
        }, { prefix = '<leader>' })

        -- Local Leader Key Bindings
        wk.register({
            c = { ':lclose<CR>', 'Close location list' },
            p = { ":echo expand('%:p')<CR>", 'Show full path of current file' },
        }, { prefix = '\\' })

        -- Function Key Bindings
        wk.register({
            ['<F2>'] = { ':e! $MYVIMRC<CR>', 'Edit vimrc' },
            ['<F4>'] = { ':source $MYVIMRC<CR>', 'Source vimrc' },
            ['<F5>'] = { ':e!<CR>', 'Reset file from disk' },
            ['<F6>'] = { 'mzgg"+yG`z', 'Copy all file' },
            ['<F7>'] = { 'mzgg=G`z', 'Indent whole file' },
            ['<F8>'] = { ':wa<CR>:mksession!<CR>:qa!<CR>', 'Save all and close' },
            ['<F12>'] = { ':cq<CR>', 'Abort with non-zero exit code' },
        })

        -- Single Key Bindings
        wk.register({
            ['<left>'] = { '<C-w><', 'Resize window narrower' },
            ['<right>'] = { '<C-w>>', 'Resize window wider' },
            ['<up>'] = { '<C-w>+', 'Resize window taller' },
            ['<down>'] = { '<C-w>-', 'Resize window shorter' },
            j = { 'gj', 'Move down by visual line' },
            k = { 'gk', 'Move up by visual line' },
            X = { '%x``x', 'Delete matching braces' },
            Y = { 'y$', 'Yank to end of line' },
        }, { mode = 'n', silent = true })

        -- Combination Key Bindings
        wk.register({
            ['<C-n>'] = { ':bnext<CR>', 'Next buffer' },
            ['<C-p>'] = { ':bprevious<CR>', 'Previous buffer' },
            ['<C-l>'] = { ':nohlsearch<CR>', 'Clear search highlight' },
            ['<C-j>'] = { '4<C-e>', 'Scroll window down' },
            ['<C-k>'] = { '4<C-y>', 'Scroll window up' },
            gh = { '<C-w>h', 'Navigate to left window' },
            gj = { '<C-w>j', 'Navigate to bottom window' },
            gk = { '<C-w>k', 'Navigate to top window' },
            gl = { '<C-w>l', 'Navigate to right window' },
        }, { mode = 'n', silent = true })

        -- Visual Mode Bindings
        wk.register({
            ['<'] = { '<gv', 'Indent left and reselect' },
            ['>'] = { '>gv', 'Indent right and reselect' },
            y = { '"+y', 'Copy to clipboard' },
            p = { '"+p', 'Paste from clipboard' },
            P = { '"+P', 'Paste before cursor from clipboard' },
        }, { mode = 'v', silent = true })

        -- Other Key Bindings
        wk.register({
            ['[q'] = { ':cprevious<CR>', 'Previous item in quickfix' },
            [']q'] = { ':cnext<CR>', 'Next item in quickfix' },
            ['[Q'] = { ':cfirst<CR>', 'First item in quickfix' },
            [']Q'] = { ':clast<CR>', 'Last item in quickfix' },
            ['[l'] = { ':lprevious<CR>', 'Previous item in location list' },
            [']l'] = { ':lnext<CR>', 'Next item in location list' },
            ['[L'] = { ':lfirst<CR>', 'First item in location list' },
            [']L'] = { ':llast<CR>', 'Last item in location list' },
            gV = { '`[v`]', 'Highlight last inserted text' },
        }, { mode = 'n', silent = true })
    end,
}
