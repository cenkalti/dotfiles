-- Fuzzy finder and picker
return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        { 'folke/which-key.nvim' },
    },
    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')

        telescope.load_extension('fzf')

        require('telescope').setup({
            defaults = {
                mappings = {
                    -- Open visible files in separate buffers
                    i = {
                        ['<C-a>'] = function(prompt_bufnr)
                            local picker = action_state.get_current_picker(prompt_bufnr)
                            local manager = picker.manager

                            -- Get all entries
                            for entry in manager:iter() do
                                vim.cmd('badd ' .. vim.fn.fnameescape(entry.value))
                            end

                            actions.close(prompt_bufnr)
                        end,
                    },
                },
            },
        })

        local wk = require('which-key')

        wk.add({
            {
                '<leader>ff',
                function()
                    builtin.find_files({})
                end,
                desc = 'Find Files',
            },
            { '<leader>fg', "<cmd>lua require('telescope.builtin').git_files()<CR>", desc = 'Git Files' },
            { '<leader>fs', "<cmd>lua require('telescope.builtin').git_status()<CR>", desc = 'Git Files (Modified)' },
            { '<leader>fl', "<cmd>lua require('telescope.builtin').live_grep()<CR>", desc = 'Live Grep' },
            {
                '<leader>a',
                function()
                    builtin.grep_string({ search = vim.fn.input('Grep > ') })
                end,
                desc = 'Grep String Input',
            },
            { '<leader>e', "<cmd>lua require('telescope.builtin').grep_string()<CR>", desc = 'Grep String' },
            { '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", desc = 'Buffers' },
            { '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", desc = 'Help Tags' },
            { '<leader>fc', "<cmd>lua require('telescope.builtin').commands()<CR>", desc = 'Commands' },
            { '<leader>fd', "<cmd>lua require('telescope.builtin').diagnostics()<CR>", desc = 'Diagnostics' },
            {
                '<leader>o',
                "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",
                desc = 'LSP Document Symbols',
            },
            {
                '<leader>O',
                "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>",
                desc = 'LSP Workspace Symbols',
            },
        })
    end,
}
