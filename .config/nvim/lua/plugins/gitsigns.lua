-- Show git status on gutter
return {
    'lewis6991/gitsigns.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'folke/which-key.nvim',
    },
    config = function()
        require('gitsigns').setup({
            on_attach = function(_)
                require('which-key').add({
                    -- Navigation
                    { ']c', "<cmd>lua require('gitsigns').next_hunk()<CR>", desc = 'Next Hunk' },
                    { '[c', "<cmd>lua require('gitsigns').prev_hunk()<CR>", desc = 'Previous Hunk' },

                    -- Actions
                    { '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', desc = 'Stage Hunk' },
                    { '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', desc = 'Reset Hunk' },
                    { '<leader>hS', "<cmd>lua require('gitsigns').stage_buffer()<CR>", desc = 'Stage Buffer' },
                    { '<leader>hu', "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", desc = 'Undo Stage Hunk' },
                    { '<leader>hR', "<cmd>lua require('gitsigns').reset_buffer()<CR>", desc = 'Reset Buffer' },
                    { '<leader>hp', "<cmd>lua require('gitsigns').preview_hunk()<CR>", desc = 'Preview Hunk' },
                    { '<leader>hb', "<cmd>lua require('gitsigns').blame_line{full=true}<CR>", desc = 'Blame Line' },
                    {
                        '<leader>tb',
                        "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>",
                        desc = 'Toggle Line Blame',
                    },
                    { '<leader>hd', "<cmd>lua require('gitsigns').diffthis()<CR>", desc = 'Diff This' },
                    { '<leader>hD', "<cmd>lua require('gitsigns').diffthis('~')<CR>", desc = 'Diff This ~' },
                    { '<leader>td', "<cmd>lua require('gitsigns').toggle_deleted()<CR>", desc = 'Toggle Deleted' },

                    { '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', desc = 'Stage Hunk', mode = 'v' },
                    { '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', desc = 'Reset Hunk', mode = 'v' },
                })
            end,
        })
    end,
}
