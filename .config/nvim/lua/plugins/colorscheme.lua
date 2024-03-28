return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function ()
    if vim.fn.exists('+termguicolors') == 1 then
      -- Fixes colors inside Tmux
      vim.o.t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"
      vim.o.t_8b = "\\<Esc>[48;2;%lu;%lu;%lum"
    end
    vim.o.termguicolors = true
    vim.cmd[[colorscheme tokyonight]]
  end,
}
