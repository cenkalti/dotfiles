-- An extension for telescope.nvim that allows you to switch between projects.
return {
  'ahmedkhalf/project.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function ()
    require("project_nvim").setup()
    require('telescope').load_extension('projects')
  end
}
