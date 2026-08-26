-- Fuzzy finder and picker
return {
    'nvim-telescope/telescope.nvim',
    version = '*',
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
                    builtin.find_files({ no_ignore = true, hidden = true, follow = true })
                end,
                desc = 'Find Files',
            },
            { '<leader>fg', "<cmd>lua require('telescope.builtin').git_files()<CR>", desc = 'Git Files' },
            { '<leader>fm', "<cmd>lua require('telescope.builtin').git_status()<CR>", desc = 'Git Files (Modified)' },
            { '<leader>fl', "<cmd>lua require('telescope.builtin').live_grep()<CR>", desc = 'Live Grep' },
            {
                '<leader>a',
                function()
                    builtin.grep_string({ search = vim.fn.input('Grep > ') })
                end,
                desc = 'Grep String Input',
            },
            {
                '<leader>A',
                function()
                    builtin.grep_string({ search = vim.fn.input('Grep > '), additional_args = { '--hidden' } })
                end,
                desc = 'Grep String Input (+ hidden)',
            },
            { '<leader>e', "<cmd>lua require('telescope.builtin').grep_string()<CR>", desc = 'Grep String' },
            {
                '<leader>E',
                function()
                    builtin.grep_string({ additional_args = { '--hidden' } })
                end,
                desc = 'Grep String (+ hidden)',
            },
            { '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", desc = 'Buffers' },
            { '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", desc = 'Help Tags' },
            { '<leader>fc', "<cmd>lua require('telescope.builtin').commands()<CR>", desc = 'Commands' },
            { '<leader>fd', "<cmd>lua require('telescope.builtin').diagnostics()<CR>", desc = 'Diagnostics' },
            {
                '<leader>fs',
                "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",
                desc = 'LSP Document Symbols',
            },
            {
                '<leader>fS',
                "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>",
                desc = 'LSP Workspace Symbols',
            },
            {
                -- Re-queries the server on every keystroke, so the server's own matcher
                -- does the filtering. gopls returns nothing for the empty query <leader>fS
                -- sends, so seed the prompt with the word under the cursor. Telescope has no
                -- capability check on this picker, so warn rather than show an empty list.
                '<leader>fw',
                function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    local supported = false
                    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                        supported = supported or client:supports_method('workspace/symbol', bufnr)
                    end
                    if not supported then
                        vim.notify('No LSP client here supports workspace/symbol', vim.log.levels.WARN)
                        return
                    end
                    builtin.lsp_dynamic_workspace_symbols({ default_text = vim.fn.expand('<cword>') })
                end,
                desc = 'LSP Workspace Symbols (dynamic)',
            },
            {
                '<leader>fp',
                function()
                    local pickers = require('telescope.pickers')
                    local finders = require('telescope.finders')
                    local conf = require('telescope.config').values
                    local make_entry = require('telescope.make_entry')

                    local files = vim.fn.systemlist('git diff-tree --no-commit-id --name-only -r HEAD')

                    pickers
                        .new({}, {
                            prompt_title = 'Files Changed in Last Commit',
                            finder = finders.new_table({
                                results = files,
                                entry_maker = make_entry.gen_from_file({}),
                            }),
                            sorter = conf.file_sorter({}),
                            previewer = conf.file_previewer({}),
                        })
                        :find()
                end,
                desc = 'Files Changed in Last Commit',
            },
        })
    end,
}
