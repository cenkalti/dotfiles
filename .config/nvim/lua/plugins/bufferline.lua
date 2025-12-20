-- Show open buffers on top and switch with <leader>1..9
return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'folke/which-key.nvim',
    },
    config = function()
        vim.opt.termguicolors = true

        local bufferline = require('bufferline')
        bufferline.setup({
            options = {
                style_preset = bufferline.style_preset.default,
                separator_style = { '', '' },
                indicator = {
                    style = 'underline',
                },
                numbers = function(opts)
                    return opts.raise(opts.ordinal)
                end,
                show_close_icon = false,
                show_buffer_close_icons = false,
                diagnostics = 'nvim_lsp',
                diagnostics_indicator = function(count, level)
                    local icon = level:match('error') and ' ' or ' '
                    return ' ' .. icon .. count
                end,
                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = function()
                            return 'cwd: ' .. vim.fn.getcwd():match('([^/\\]+)$')
                        end,
                        highlight = 'Directory',
                        text_align = 'left',
                    },
                },
            },
        })

        local wk = require('which-key')

        -- Buffer navigation
        wk.add({
            { '<leader>1', "<cmd>lua require('bufferline').go_to_buffer(1, true)<CR>", desc = 'Go to Buffer 1' },
            { '<leader>2', "<cmd>lua require('bufferline').go_to_buffer(2, true)<CR>", desc = 'Go to Buffer 2' },
            { '<leader>3', "<cmd>lua require('bufferline').go_to_buffer(3, true)<CR>", desc = 'Go to Buffer 3' },
            { '<leader>4', "<cmd>lua require('bufferline').go_to_buffer(4, true)<CR>", desc = 'Go to Buffer 4' },
            { '<leader>5', "<cmd>lua require('bufferline').go_to_buffer(5, true)<CR>", desc = 'Go to Buffer 5' },
            { '<leader>6', "<cmd>lua require('bufferline').go_to_buffer(6, true)<CR>", desc = 'Go to Buffer 6' },
            { '<leader>7', "<cmd>lua require('bufferline').go_to_buffer(7, true)<CR>", desc = 'Go to Buffer 7' },
            { '<leader>8', "<cmd>lua require('bufferline').go_to_buffer(8, true)<CR>", desc = 'Go to Buffer 8' },
            { '<leader>9', "<cmd>lua require('bufferline').go_to_buffer(9, true)<CR>", desc = 'Go to Buffer 9' },
            { '<leader>$', "<cmd>lua require('bufferline').go_to_buffer(-1, true)<CR>", desc = 'Go to Last Buffer' },
        }, { silent = true })

        -- Cycle through buffers
        wk.add({
            { '<C-n>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next Buffer' },
            { '<C-p>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous Buffer' },
        }, { silent = true })

        -- Move buffers
        wk.add({
            { '<C-A-n>', '<cmd>BufferLineMoveNext<CR>', desc = 'Move Buffer Next' },
            { '<C-A-p>', '<cmd>BufferLineMovePrev<CR>', desc = 'Move Buffer Previous' },
        })

        -- Other
        wk.add({ { '<leader>bb', '<cmd>BufferLineCloseOthers<CR>', desc = 'Close Other Buffers' } }, { silent = true })
        wk.add({ { '<leader>bh', '<cmd>BufferLineCloseLeft<CR>', desc = 'Close Buffers Left' } }, { silent = true })
        wk.add({ { '<leader>bl', '<cmd>BufferLineCloseRight<CR>', desc = 'Close Buffers Right' } }, { silent = true })
    end,
}
