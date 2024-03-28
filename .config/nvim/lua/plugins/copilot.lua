-- GitHub Copilot
return {
  'zbirenbaum/copilot.lua',
  config = function()
    require("copilot").setup({
      panel = {
        enabled = false,
      },
      suggestion = {
        auto_trigger = true,
      },
      filetypes = {
        ["*"] = true,
      },
    })
  end,
}
