-- Replace with register: `cr{motion}` (e.g., `crw`, `criw`, `cr$`)
-- Replaces vim-ReplaceWithRegister plugin (gr conflicts with neovim 0.12 defaults)

-- cr{motion}: set our function as the operator, g@ waits for the motion
vim.keymap.set('n', 'cr', function()
  vim.o.operatorfunc = 'v:lua.__replace_with_register'
  return 'g@'
end, { expr = true })

-- crr: replace entire line (g@_ applies the operator to the current line)
vim.keymap.set('n', 'crr', function()
  vim.o.operatorfunc = 'v:lua.__replace_with_register'
  return 'g@_'
end, { expr = true })

-- visual mode: paste over selection
vim.keymap.set('x', 'cr', function()
  vim.cmd('normal! "' .. vim.v.register .. 'p')
end)

-- operatorfunc callback: visually select the motion range (`[..`]) and paste over it
function __replace_with_register(type)
  local reg = vim.v.register
  local sel = type == 'line' and 'V' or type == 'block' and '\22' or 'v'
  vim.cmd('normal! `[' .. sel .. '`]"' .. reg .. 'p')
end

return {}
