return {
    'folke/which-key.nvim',
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
        wk.add({
            { '<leader>D', ':bd!<CR>', desc = 'Close current buffer' },
            { '<leader>q', ':%bd<CR>', desc = 'Close all buffers' },
            { '<leader>Q', ':qa!<CR>', desc = 'Quit Neovim without saving' },
            { '<leader>w', 'ciw', desc = 'Change word under cursor' },
            { '<leader>W', 'ciW', desc = 'Change WORD under cursor' },
            {
                '<leader>s',
                ":set hlsearch<CR>:let @/='\\<'..expand('<cword>')..'\\>'<CR>",
                desc = 'Highlight word under cursor',
            },
            { '<leader>c', ':cclose<CR>', desc = 'Close quickfix list' },
            { '<leader>y', '"+y', desc = 'Copy to clipboard' },
            { '<leader>Y', '"+yg_', desc = 'Copy to end of line to clipboard' },
            { '<leader>p', '"+p', desc = 'Paste from clipboard' },
            { '<leader>P', '"+P', desc = 'Paste before cursor from clipboard' },
        })

        -- Local Leader Key Bindings
        wk.add({
            { '\\c', ':lclose<CR>', desc = 'Close location list' },
            { '\\p', ":echo expand('%:p')<CR>", desc = 'Show full path of current file' },
        })

        -- Function Key Bindings
        wk.add({
            { '<F2>', ':e! $MYVIMRC<CR>', desc = 'Edit vimrc' },
            { '<F4>', ':source $MYVIMRC<CR>', desc = 'Source vimrc' },
            { '<F5>', ':e!<CR>', desc = 'Reset file from disk' },
            { '<F6>', 'mzgg"+yG`z', desc = 'Copy all file' },
            { '<F7>', 'mzgg=G`z', desc = 'Indent whole file' },
            { '<F8>', ':wa<CR>:mksession!<CR>:qa!<CR>', desc = 'Save all and close' },
            { '<F12>', ':cq<CR>', desc = 'Abort with non-zero exit code' },
        })

        -- Single Key Bindings
        wk.add({
            { '<left>', '<C-w><', desc = 'Resize window narrower' },
            { '<right>', '<C-w>>', desc = 'Resize window wider' },
            { '<up>', '<C-w>+', desc = 'Resize window taller' },
            { '<down>', '<C-w>-', desc = 'Resize window shorter' },
            { 'j', 'gj', desc = 'Move down by visual line' },
            { 'k', 'gk', desc = 'Move up by visual line' },
            { 'X', '%x``x', desc = 'Delete matching braces' },
            { 'Y', 'y$', desc = 'Yank to end of line' },
        })

        -- Combination Key Bindings
        wk.add({
            { '<C-l>', ':nohlsearch<CR>', desc = 'Clear search highlight' },
            { '<C-j>', '4<C-e>', desc = 'Scroll window down' },
            { '<C-k>', '4<C-y>', desc = 'Scroll window up' },
            { 'gh', '<C-w>h', desc = 'Navigate to left window' },
            { 'gj', '<C-w>j', desc = 'Navigate to bottom window' },
            { 'gk', '<C-w>k', desc = 'Navigate to top window' },
            { 'gl', '<C-w>l', desc = 'Navigate to right window' },
        })

        -- Visual Mode Bindings
        wk.add({
            mode = 'v',
            { '<C-j>', '4<C-e>', desc = 'Scroll window down' },
            { '<C-k>', '4<C-y>', desc = 'Scroll window up' },
            { '<', '<gv', desc = 'Indent left and reselect' },
            { '>', '>gv', desc = 'Indent right and reselect' },
            { 'y', '"+y', desc = 'Copy to clipboard' },
            { 'p', '"+p', desc = 'Paste from clipboard' },
            { 'P', '"+P', desc = 'Paste before cursor from clipboard' },
        })

        -- Other Key Bindings
        wk.add({
            { '[q', ':cprevious<CR>', desc = 'Previous item in quickfix' },
            { ']q', ':cnext<CR>', desc = 'Next item in quickfix' },
            { '[Q', ':cfirst<CR>', desc = 'First item in quickfix' },
            { ']Q', ':clast<CR>', desc = 'Last item in quickfix' },
            { '[l', ':lprevious<CR>', desc = 'Previous item in location list' },
            { ']l', ':lnext<CR>', desc = 'Next item in location list' },
            { '[L', ':lfirst<CR>', desc = 'First item in location list' },
            { ']L', ':llast<CR>', desc = 'Last item in location list' },
            { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', desc = 'Previous Diagnostic' },
            { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', desc = 'Next Diagnostic' },
            { 'gV', '`[v`]', desc = 'Highlight last inserted text' },
        })
    end,
}
