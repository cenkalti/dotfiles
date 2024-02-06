-- Change quotes with `cs'"`, delete with `ds"`.
return {
  'tpope/vim-surround',
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function ()
    require("which-key").register({
      ["<leader>'"] = { "<cmd>normal cs\"'<CR>", "Toggle to Single Quotes" },
      ["<leader>\""] = { "<cmd>normal cs'\"<CR>", "Toggle to Double Quotes" },
    })
  end
}
