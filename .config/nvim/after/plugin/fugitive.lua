local wk = require("which-key")

wk.register({
  ["<leader>gs"] = { "<cmd>Git<CR>", "View Git Status" },
  ["gb"] = { "<cmd>GBrowse<CR>", "View HTTP Link" },
}) -- Normal mode mapping

wk.register({
  ["gb"] = { "<cmd>GBrowse<CR>", "View HTTP Link" },
}, { mode = "v" })

