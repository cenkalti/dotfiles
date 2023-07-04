-- Search with 2 letters
return {
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    config = function()
      local hop = require('hop')
      hop.setup()
      vim.keymap.set('', 's', hop.hint_char2, {remap=true})
    end,
  },
}
