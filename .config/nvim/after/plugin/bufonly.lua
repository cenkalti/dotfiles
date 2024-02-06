local wk = require("which-key")

wk.register({
  ["<leader>b"] = { "<cmd>BufOnly<CR>", "Wipe Other Buffers" },
}, { silent = true })

