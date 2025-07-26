-- Windsurf AI code completion
return {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = function()
        local neocodeium = require('neocodeium')
        neocodeium.setup({
            silent = true,
            filter = function(bufnr)
                if vim.endswith(vim.api.nvim_buf_get_name(bufnr), '.env') then
                    return false
                end
                return true
            end,
        })

        -- Make sure these are in line with blink.cmp keybindings
        vim.keymap.set('i', '<A-y>', function()
            neocodeium.accept()
        end)
        vim.keymap.set('i', '<A-w>', function()
            neocodeium.accept_word()
        end)
        vim.keymap.set('i', '<A-l>', function()
            neocodeium.accept_line()
        end)
        vim.keymap.set('i', '<A-Space>', function()
            neocodeium.cycle_or_complete(1)
        end)
        vim.keymap.set('i', '<A-j>', function()
            neocodeium.cycle(1)
        end)
        vim.keymap.set('i', '<A-k>', function()
            neocodeium.cycle(-1)
        end)
        vim.keymap.set('i', '<A-e>', function()
            neocodeium.clear()
        end)
    end,
}
