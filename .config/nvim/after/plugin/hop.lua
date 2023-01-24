local hop = require('hop')

hop.setup()

vim.keymap.set('', 's', hop.hint_char2, {remap=true})

vim.keymap.set('', '/', function()
    hop.hint_patterns()
    vim.cmd("set hlsearch | let @/='\\<'.expand('<cword>').'\\>'")
end, {remap=true})
