return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "antosha417/nvim-lsp-file-operations",
      "folke/which-key.nvim",
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
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        git = {
          ignore = false,
          show_on_open_dirs = false,
        },
      })

      local wk = require("which-key")

      wk.register({
        ["<Leader>n"] = { "<cmd>NvimTreeToggle<CR>", "Toggle Nvim Tree" },
        ["<Leader>r"] = { "<cmd>NvimTreeFindFile<CR>", "Find File in Nvim Tree" },
      })

    end,
  },
}
