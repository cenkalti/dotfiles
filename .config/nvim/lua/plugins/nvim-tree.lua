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
        -- Changes the tree root directory on `DirChanged` and refreshes the tree.
        sync_root_with_cwd = true,
        -- Will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
        respect_buf_cwd = true,
        -- Update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file.
        update_focused_file = {
          enable = true,
          -- Update the root directory of the tree if the file is not under current root directory.
          -- It prefers vim's cwd and `root_dirs`. Otherwise it falls back to the folder containing the file.
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
