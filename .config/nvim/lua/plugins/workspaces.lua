-- An extension to switch between projects in telescope
return {
  'natecraddock/workspaces.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function ()
    require('workspaces').setup({
      hooks = {
        open = { "Telescope find_files" },
      },
    })
    require('telescope').load_extension('workspaces')
    require("which-key").register({
      w = {":lua require'telescope'.extensions.workspaces.workspaces{}<CR>", "Switch workspace"},
    }, { prefix = "\\" })
  end
}
