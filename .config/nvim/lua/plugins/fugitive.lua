-- Git commands
return {
  'tpope/vim-fugitive',
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function ()
    local wk = require("which-key")

    wk.register({
      ["<leader>gs"] = { "<cmd>Git<CR>", "View Git Status" },
      ["gb"] = { "<cmd>GBrowse<CR>", "View HTTP Link" },
    })

    wk.register({
      ["gb"] = { "<cmd>GBrowse<CR>", "View HTTP Link" },
    }, { mode = "v" })

  end
}
