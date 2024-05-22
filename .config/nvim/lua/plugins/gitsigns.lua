-- Show git status on gutter
return {
    'lewis6991/gitsigns.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'folke/which-key.nvim',
    },
    config = function()
        require('gitsigns').setup({
            on_attach = function(bufnr)
                require('which-key').register({

                    -- Navigation
                    [']c'] = { "<cmd>lua require('gitsigns').next_hunk()<CR>", 'Next Hunk' },
                    ['[c'] = { "<cmd>lua require('gitsigns').prev_hunk()<CR>", 'Previous Hunk' },

                    -- Actions
                    ['<leader>hs'] = { '<cmd>Gitsigns stage_hunk<CR>', 'Stage Hunk' },
                    ['<leader>hr'] = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset Hunk' },

                    ['<leader>hS'] = { "<cmd>lua require('gitsigns').stage_buffer()<CR>", 'Stage Buffer' },
                    ['<leader>hu'] = { "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", 'Undo Stage Hunk' },
                    ['<leader>hR'] = { "<cmd>lua require('gitsigns').reset_buffer()<CR>", 'Reset Buffer' },
                    ['<leader>hp'] = { "<cmd>lua require('gitsigns').preview_hunk()<CR>", 'Preview Hunk' },
                    ['<leader>hb'] = { "<cmd>lua require('gitsigns').blame_line{full=true}<CR>", 'Blame Line' },
                    ['<leader>tb'] = {
                        "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>",
                        'Toggle Line Blame',
                    },
                    ['<leader>hd'] = { "<cmd>lua require('gitsigns').diffthis()<CR>", 'Diff This' },
                    ['<leader>hD'] = { "<cmd>lua require('gitsigns').diffthis('~')<CR>", 'Diff This ~' },
                    ['<leader>td'] = { "<cmd>lua require('gitsigns').toggle_deleted()<CR>", 'Toggle Deleted' },
                }, { mode = 'n', buffer = bufnr })

                require('which-key').register({
                    ['<leader>hs'] = { '<cmd>Gitsigns stage_hunk<CR>', 'Stage Hunk' },
                    ['<leader>hr'] = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset Hunk' },
                }, { mode = 'v', buffer = bufnr })
            end,
        })
    end,
}
