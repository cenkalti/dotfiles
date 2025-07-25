-- Windsurf AI code completion
return {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = function()
        local neocodeium = require('neocodeium')
        neocodeium.setup()

        vim.keymap.set('i', '<Tab>', function()
            neocodeium.accept()
        end)
        vim.keymap.set('i', '<A-w>', function()
            neocodeium.accept_word()
        end)
        vim.keymap.set('i', '<A-l>', function()
            neocodeium.accept_line()
        end)
        vim.keymap.set('i', '<A-j>', function()
            neocodeium.cycle_or_complete(1)
        end)
        vim.keymap.set('i', '<A-k>', function()
            neocodeium.cycle_or_complete(-1)
        end)
        vim.keymap.set('i', '<A-c>', function()
            neocodeium.clear()
        end)
    end,
}
