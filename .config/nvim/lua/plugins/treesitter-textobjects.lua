-- Syntax aware text-objects: select, move, swap
return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    config = function()
        require('nvim-treesitter-textobjects').setup({
            select = {
                lookahead = true,
                selection_modes = {
                    ['@function.inner'] = 'V',
                    ['@function.outer'] = 'V',
                },
            },
            move = {
                set_jumps = true,
            },
        })

        local select = require('nvim-treesitter-textobjects.select')
        vim.keymap.set({ 'x', 'o' }, 'af', function()
            select.select_textobject('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'x', 'o' }, 'if', function()
            select.select_textobject('@function.inner', 'textobjects')
        end)

        local swap = require('nvim-treesitter-textobjects.swap')
        vim.keymap.set('n', '<localleader>s', function()
            swap.swap_next('@parameter.inner')
        end)
        vim.keymap.set('n', '<localleader>f', function()
            swap.swap_next('@function.outer')
        end)
        vim.keymap.set('n', '<localleader>S', function()
            swap.swap_previous('@parameter.inner')
        end)
        vim.keymap.set('n', '<localleader>F', function()
            swap.swap_previous('@function.outer')
        end)

        local move = require('nvim-treesitter-textobjects.move')
        vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
            move.goto_next_start('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, ']i', function()
            move.goto_next_start('@function.inner', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, ']t', function()
            move.goto_next_start('@class.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
            move.goto_next_end('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, ']I', function()
            move.goto_next_end('@function.inner', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
            move.goto_previous_start('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[i', function()
            move.goto_previous_start('@function.inner', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[t', function()
            move.goto_previous_start('@class.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
            move.goto_previous_end('@function.outer', 'textobjects')
        end)
        vim.keymap.set({ 'n', 'x', 'o' }, '[I', function()
            move.goto_previous_end('@function.inner', 'textobjects')
        end)

        local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')

        -- Repeat movement with ; and ,
        -- ensure ; goes forward and , goes backward regardless of the last direction
        vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
        vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
    end,
}
