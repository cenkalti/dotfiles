return {
    {
        'nvim-tree/nvim-tree.lua',
        version = '*',
        lazy = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'antosha417/nvim-lsp-file-operations',
            'folke/which-key.nvim',
        },
        config = function()
            require('nvim-tree').setup({
                view = {
                    width = '20%',
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                    custom = { '__pycache__' },
                },
                filesystem_watchers = {
                    enable = false,
                },
                -- Changes the tree root directory on `DirChanged` and refreshes the tree.
                sync_root_with_cwd = true,
                -- Will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
                respect_buf_cwd = true,
                -- Update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file.
                update_focused_file = {
                    enable = true,
                    -- Update the root directory of the tree if the file is not under current root directory.
                    -- It prefers vim's cwd and `root_dirs`. Otherwise it falls back to the folder containing the file.
                    update_root = true,
                },
                git = {
                    ignore = false,
                    show_on_open_dirs = false,
                },
            })

            require('which-key').register({
                ['<Leader>n'] = { '<cmd>NvimTreeToggle<CR>', 'Toggle Nvim Tree' },
                ['<Leader>r'] = { '<cmd>NvimTreeFindFile<CR>', 'Find File in Nvim Tree' },
            })

            -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#marvinth01
            vim.api.nvim_create_autocmd('QuitPre', {
                callback = function()
                    local invalid_win = {}
                    local wins = vim.api.nvim_list_wins()
                    for _, w in ipairs(wins) do
                        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                        if bufname:match('NvimTree_') ~= nil then
                            table.insert(invalid_win, w)
                        end
                    end
                    if #invalid_win == #wins - 1 then
                        -- Should quit, so we close all invalid windows.
                        for _, w in ipairs(invalid_win) do
                            vim.api.nvim_win_close(w, true)
                        end
                    end
                end,
            })
        end,
    },
}
