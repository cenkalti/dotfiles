local lsp = require('lsp-zero')
lsp.preset('recommended')

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.set_preferences({
  -- I'll set my own key bindings
  set_lsp_keymaps = false
})

lsp.on_attach(function(client, bufnr)
  require('illuminate').on_attach(client)

  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'L', vim.lsp.buf.signature_help, opts)

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gR', vim.lsp.buf.references, opts)

  vim.keymap.set('n', '<localleader>r', vim.lsp.buf.rename, opts)
end)

local cmp = require('cmp')
lsp.setup_nvim_cmp({
  mapping = {
    ['<C-e>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping.confirm(),
    ['<C-c>'] = cmp.mapping.close(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
  },
})

lsp.setup()

local opts = { noremap=true, silent=true }

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Configure LSP diagnostic messages
vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = true,
  update_in_insert = false,
})

-- Show diagnostic message as floating window when hover on line
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]]