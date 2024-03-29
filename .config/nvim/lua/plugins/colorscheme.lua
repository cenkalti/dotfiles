return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function ()
    vim.o.termguicolors = true
    vim.cmd[[colorscheme tokyonight]]
  end,
}
