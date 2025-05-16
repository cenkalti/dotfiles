-- Codeium AI code completion
return {
    'Exafunction/codeium.vim',
    init = function()
        vim.g.codeium_disable_bindings = 1
    end,
    config = function()
        vim.keymap.set('i', '<Tab>', function()
            return vim.fn['codeium#Accept']()
        end, { expr = true, silent = true })
        vim.keymap.set('i', '<C-j>', function()
            return vim.fn['codeium#CycleCompletions'](1)
        end, { expr = true, silent = true })
        vim.keymap.set('i', '<C-k>', function()
            return vim.fn['codeium#CycleCompletions'](-1)
        end, { expr = true, silent = true })
    end,
}
