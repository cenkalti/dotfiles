return {
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'folke/which-key.nvim' },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      telescope.load_extension('fzf')

      local project_actions = require("telescope._extensions.project.actions")
      require('telescope').setup({
        extensions = {
          project = {
            cd_scope = { "global" },
            base_dirs = {
              '~/projects',
            },
            sync_with_nvim_tree = true,
          },
        },
      })

      local wk = require("which-key")

      wk.register({
        ["<leader>ff"] = { function() builtin.find_files({ no_ignore = true }) end, "Find Files" },
        ["<leader>fg"] = { "<cmd>lua require('telescope.builtin').git_files()<CR>", "Git Files" },
        ["<leader>fl"] = { "<cmd>lua require('telescope.builtin').live_grep()<CR>", "Live Grep" },
        ["<leader>a"] = { function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end, "Grep String Input" },
        ["<leader>e"] = { "<cmd>lua require('telescope.builtin').grep_string()<CR>", "Grep String" },
        ["<leader>fb"] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
        ["<leader>fh"] = { "<cmd>lua require('telescope.builtin').help_tags()<CR>", "Help Tags" },
        ["<leader>fc"] = { "<cmd>lua require('telescope.builtin').commands()<CR>", "Commands" },
        ["<leader>o"] = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", "LSP Document Symbols" },
        ["<leader>O"] = { "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", "LSP Workspace Symbols" },
      })

    end,
  },
}
