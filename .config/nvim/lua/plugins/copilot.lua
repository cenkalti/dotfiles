-- GitHub Copilot
return {
  'zbirenbaum/copilot.lua',
  config = function()
    require("copilot").setup({
      suggestion = {
        auto_trigger = true,
      },
      filetypes = {
        ["*"] = true,
      },
    })
  end,
}
