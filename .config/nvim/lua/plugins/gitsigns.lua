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
                local gs = require('gitsigns')
                require('which-key').add({
                    -- Navigation
                    { ']c', gs.next_hunk, desc = 'Next Hunk' },
                    { '[c', gs.prev_hunk, desc = 'Previous Hunk' },

                    -- Actions
                    { '<leader>gs', gs.stage_hunk, desc = 'Stage Hunk' },
                    { '<leader>gu', gs.undo_stage_hunk, desc = 'Undo Stage Hunk' },
                    { '<leader>gr', gs.reset_hunk, desc = 'Reset Hunk' },

                    { '<leader>gS', gs.stage_buffer, desc = 'Stage Buffer' },
                    { '<leader>gR', gs.reset_buffer, desc = 'Reset Buffer' },

                    { '<leader>gp', gs.preview_hunk, desc = 'Preview Hunk' },
                    { '<leader>gb', gs.blame_line, desc = 'Blame Line' },
                    { '<leader>gd', gs.diffthis, desc = 'Diff This' },

                    { '<leader>gtd', gs.toggle_deleted, desc = 'Toggle Deleted' },
                    { '<leader>gtb', gs.toggle_current_line_blame, desc = 'Toggle Line Blame' },

                    { '<leader>gs', gs.stage_hunk, desc = 'Stage Hunk', mode = 'v' },
                    { '<leader>gr', gs.reset_hunk, desc = 'Reset Hunk', mode = 'v' },
                })
            end,
        })

        -- Refresh gitsigns when gaining focus (e.g., after git commit in terminal)
        vim.api.nvim_create_autocmd('FocusGained', {
            group = vim.api.nvim_create_augroup('gitsigns_refresh', { clear = true }),
            callback = function()
                require('gitsigns').refresh()
            end,
        })
    end,
}
