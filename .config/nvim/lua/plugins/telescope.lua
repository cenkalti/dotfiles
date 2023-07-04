return {
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      telescope.load_extension('fzf')

      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = actions.close,
            },
          },
        },
      }

      vim.keymap.set('n', '<leader>ff', function()
        builtin.find_files({ no_ignore = true })
      end, {})
      vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
      vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>a', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)
      vim.keymap.set('n', '<leader>e', builtin.grep_string, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>fc', builtin.commands, {})
      vim.keymap.set('n', '<leader>o', builtin.lsp_document_symbols, {})
      vim.keymap.set('n', '<leader>O', builtin.lsp_workspace_symbols, {})
    end,
  },
}
