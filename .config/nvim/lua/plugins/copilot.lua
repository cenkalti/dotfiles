-- GitHub Copilot
return {
    'zbirenbaum/copilot.lua',
    enabled = false,
    config = function()
        require('copilot').setup({
            panel = {
                enabled = false,
            },
            suggestion = {
                auto_trigger = true,
            },
            filetypes = {
                ['*'] = true,
            },
        })
    end,
}
