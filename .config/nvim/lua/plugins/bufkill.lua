-- Delete buffer without changing window layout
return {
  'qpkorr/vim-bufkill',
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function ()
    require("which-key").register({
      ["<leader>d"] = { "<cmd>BW<CR>", "Wipe Buffer" },
    })
  end
}
