return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "antosha417/nvim-lsp-file-operations",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = '20%',
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
          custom = { '__pycache__' },
        },
        filesystem_watchers = {
          enable = false,
        },
        update_focused_file = {
          update_root = true,
        },
        git = {
          ignore = false,
          show_on_open_dirs = false,
        },
      })
      vim.keymap.set('n', '<Leader>n', vim.cmd.NvimTreeToggle)
      vim.keymap.set('n', '<Leader>r', vim.cmd.NvimTreeFindFile)
    end,
  },
}
