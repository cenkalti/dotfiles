-- Delete all buffers except current one
return {
  'vim-scripts/BufOnly.vim',
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function ()
    require("which-key").register({
      ["<leader>b"] = { "<cmd>BufOnly<CR>", "Wipe Other Buffers" },
    }, { silent = true })
  end
}
