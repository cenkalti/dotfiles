return {
    'joshuavial/aider.nvim',
    dependencies = {
        { 'folke/which-key.nvim' },
    },
    config = function()
        require('aider').setup({
            auto_manage_context = true, -- automatically manage buffer context
            default_bindings = false, -- use default <leader>A keybindings
            debug = false, -- enable debug logging
        })

        local wk = require('which-key')
        wk.add({
            { '<localleader>a', ':AiderOpen<CR>', desc = 'Open a terminal window with the Aider command' },
        })
    end,
}
