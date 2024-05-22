-- Search with 2 letters
return {
    {
        'phaazon/hop.nvim',
        dependencies = {
            { 'folke/which-key.nvim' },
        },
        branch = 'v2',
        config = function()
            local hop = require('hop')
            local wk = require('which-key')
            hop.setup()
            wk.register({
                s = { "<cmd>lua require('hop').hint_char2()<cr>", 'Hop 2 Chars' },
            })
        end,
    },
}
