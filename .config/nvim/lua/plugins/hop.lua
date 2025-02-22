-- Search with 2 letters
return {
    'smoka7/hop.nvim',
    version = '*',
    dependencies = {
        { 'folke/which-key.nvim' },
    },
    config = function()
        local hop = require('hop')
        local wk = require('which-key')
        hop.setup()
        wk.add({
            { 's', "<cmd>lua require('hop').hint_char2()<cr>", desc = 'Hop 2 Chars' },
        })
    end,
}
