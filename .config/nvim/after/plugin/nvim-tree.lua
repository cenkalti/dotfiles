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
