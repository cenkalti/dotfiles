-- Status line

local function truncate_string(str, maxLength)
    if #str > maxLength then
        return string.sub(str, 1, maxLength - 3) .. "..."
    else
        return str
    end
end

local function tree_location()
  local status_line = require('nvim-treesitter').statusline({
    type_patterns = {'function', 'method'},
    indicator_size = 1000, -- large number to disable
  })
  return truncate_string(status_line, 100)
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          disabled_filetypes = { 'NvimTree' },
        },
        sections = {
          lualine_c = {'filename', tree_location},
        },
      })
    end,
  },
}
