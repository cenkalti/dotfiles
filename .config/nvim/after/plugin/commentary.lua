local wk = require("which-key")

wk.register({
  ["<LocalLeader><CR>"] = { "yypk:Commentary<CR>j", "Duplicate & Comment" },
}, { silent = true })

