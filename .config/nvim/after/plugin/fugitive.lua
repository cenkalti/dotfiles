-- View git status
vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

-- View http link for current buffer
vim.keymap.set("n", "gb", vim.cmd.GBrowse);
vim.keymap.set("v", "gb", vim.cmd.GBrowse);
