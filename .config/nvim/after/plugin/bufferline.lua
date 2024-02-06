vim.opt.termguicolors = true

require("bufferline").setup{
  options = {
    numbers = 'ordinal',
    show_close_icon = false,
    show_buffer_close_icons = false,
  },
}

local wk = require("which-key")

-- Buffer navigation
wk.register({
  ["<leader>1"] = { "<cmd>lua require('bufferline').go_to_buffer(1, true)<CR>", "Go to Buffer 1" },
  ["<leader>2"] = { "<cmd>lua require('bufferline').go_to_buffer(2, true)<CR>", "Go to Buffer 2" },
  ["<leader>3"] = { "<cmd>lua require('bufferline').go_to_buffer(3, true)<CR>", "Go to Buffer 3" },
  ["<leader>4"] = { "<cmd>lua require('bufferline').go_to_buffer(4, true)<CR>", "Go to Buffer 4" },
  ["<leader>5"] = { "<cmd>lua require('bufferline').go_to_buffer(5, true)<CR>", "Go to Buffer 5" },
  ["<leader>6"] = { "<cmd>lua require('bufferline').go_to_buffer(6, true)<CR>", "Go to Buffer 6" },
  ["<leader>7"] = { "<cmd>lua require('bufferline').go_to_buffer(7, true)<CR>", "Go to Buffer 7" },
  ["<leader>8"] = { "<cmd>lua require('bufferline').go_to_buffer(8, true)<CR>", "Go to Buffer 8" },
  ["<leader>9"] = { "<cmd>lua require('bufferline').go_to_buffer(9, true)<CR>", "Go to Buffer 9" },
  ["<leader>$"] = { "<cmd>lua require('bufferline').go_to_buffer(-1, true)<CR>", "Go to Last Buffer" },
}, { silent = true })

-- Cycle through buffers
wk.register({
  ["<C-n>"] = { "<cmd>BufferLineCycleNext<CR>", "Next Buffer" },
  ["<C-p>"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
}, { silent = true })

-- Move buffers
wk.register({
  ["<C-A-n>"] = { "<cmd>BufferLineMoveNext<CR>", "Move Buffer Next" },
  ["<C-A-p>"] = { "<cmd>BufferLineMovePrev<CR>", "Move Buffer Previous" },
})
