-- An extension for telescope.nvim that allows you to switch between projects.
return {
  'nvim-telescope/telescope-project.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function ()
    require'telescope'.load_extension('project')
    -- Settings are inside telescope plugin.
  end
}
