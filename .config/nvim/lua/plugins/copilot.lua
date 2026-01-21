-- Code completion using GitHub Copilot
return {
    'github/copilot.vim',
    enabled = true,
    init = function()
        vim.g.copilot_workspace_folders = { '~/projects' }
        vim.g.copilot_no_tab_map = true
    end,
    config = function()
        -- Make sure these are in line with blink.cmp keybindings
        local wk = require('which-key').add({
            mode = 'i',
            { '<A-y>', '<Plug>(copilot-accept)', desc = 'Accept suggestion' },
            { '<A-w>', '<Plug>(copilot-accept-word)', desc = 'Accept word' },
            { '<A-l>', '<Plug>(copilot-accept-line)', desc = 'Accept line' },
            { '<A-Space>', '<Plug>(copilot-suggest)', desc = 'Suggest' },
            { '<A-j>', '<Plug>(copilot-next)', desc = 'Next suggestion' },
            { '<A-k>', '<Plug>(copilot-previous)', desc = 'Previous suggestion' },
            { '<A-e>', '<Plug>(copilot-dismiss)', desc = 'Dismiss suggestion' },
        })
    end,
}
