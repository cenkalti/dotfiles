require("nvim-tree").setup({
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  filesystem_watchers = {
    enable = false,
  },
})

vim.keymap.set('n', '<Leader>n', vim.cmd.NvimTreeToggle)
vim.keymap.set('n', '<Leader>r', vim.cmd.NvimTreeFindFile)
