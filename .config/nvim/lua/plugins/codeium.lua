return {
    'Exafunction/codeium.vim',
    config = function()
        vim.keymap.set('i', '<M-l>', function()
            return vim.fn['codeium#Accept']()
        end, { expr = true, silent = true })
        vim.keymap.set('i', '<M-]>', function()
            return vim.fn['codeium#CycleCompletions'](1)
        end, { expr = true, silent = true })
        vim.keymap.set('i', '<M-[>', function()
            return vim.fn['codeium#CycleCompletions'](-1)
        end, { expr = true, silent = true })
        vim.keymap.set('n', '<M-c>', function()
            return vim.fn['codeium#Chat']()
        end, { expr = true, silent = true })
    end,
}
