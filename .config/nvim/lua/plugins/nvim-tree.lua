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
        update_focused_file = {
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

      -- Close the tab/nvim when nvim-tree is the last window.
      -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#naive-solution
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
            vim.cmd "quit"
          end
        end
      })

    end,
  },
}
