vim.opt.hidden = true
vim.opt.number = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = '80,120'
vim.opt.synmaxcol = 240
vim.opt.scrolloff = 5
vim.opt.sessionoptions = 'buffers,curdir,folds'
vim.opt.foldmethod = 'marker'
vim.opt.foldlevelstart = 99
vim.opt.showmode = false
vim.opt.mouse = 'a'
vim.opt.modelines = 1
vim.opt.fixendofline = false
vim.opt.updatetime = 250
vim.opt.wildmode = 'longest:full,full' -- Command completion mode

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'
