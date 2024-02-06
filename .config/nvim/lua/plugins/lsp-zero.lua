return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim', build = ":MasonUpdate"},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-nvim-lua'},
      {'L3MON4D3/LuaSnip'},

      {'folke/which-key.nvim'},
    },
    config = function ()
      local lsp = require('lsp-zero').preset({})

      lsp.set_preferences({
        -- I'll set my own key bindings
        set_lsp_keymaps = false,

        -- I'll manage LSP servers manually using :Mason
        suggest_lsp_servers = false,
      })

      -- Setup LSP key bindings
      lsp.on_attach(function(client, bufnr)
        local wk = require("which-key")

        wk.register({
          K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
          L = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },

          gd = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to Definition" },
          gD = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to Declaration" },
          gt = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to Type Definition" },
          gi = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to Implementation" },
          gR = { "<cmd>lua vim.lsp.buf.references()<CR>", "List References" },

          ["<localleader>r"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
        }, { buffer = bufnr })

      end)

      -- Setup completion key bindings
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

      -- Configure language servers
      require('lspconfig').pylsp.setup{
        settings = {
          pylsp = {
            configurationSources = {'flake8'},
          }
        }
      }

      -- Setup lsp-zero after configuration
      lsp.setup()
    end,
  },
}
