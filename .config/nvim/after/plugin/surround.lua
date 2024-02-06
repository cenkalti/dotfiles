local wk = require("which-key")

wk.register({
  ["<leader>'"] = { "<cmd>normal cs\"'<CR>", "Toggle to Single Quotes" },
  ["<leader>\""] = { "<cmd>normal cs'\"<CR>", "Toggle to Double Quotes" },
})
