-- Distraction-free writing
return {
  'folke/zen-mode.nvim',
  dependencies = {
    { 'folke/which-key.nvim' },
  },
  config = function()
    require("which-key").register({
      ["<leader>z"] = { "<cmd>ZenMode<CR>", "Zen Mode" },
    })
  end,
}
