-- Created with following tutorial:
-- https://lsp-zero.netlify.app/v3.x/tutorial.html
return {
    {
        -- LSP zero is collection of functions that will help you setup Neovim's LSP client,
        -- so you can get IDE-like features with minimum effort.
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',

        dependencies = {
            -- Contains LSP client configurations for various language servers
            { 'neovim/nvim-lspconfig' },

            -- Package manager for LSP servers, linters and formatters
            { 'williamboman/mason.nvim', build = ':MasonUpdate' },

            -- Registers a setup hook with lspconfig that ensures servers installed with mason.nvim
            -- are set up with the necessary configuration
            -- Provides extra convenience APIs such as the :LspInstall command
            { 'williamboman/mason-lspconfig.nvim' },

            -- For auto-completion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'L3MON4D3/LuaSnip' },

            -- For key bindings
            { 'folke/which-key.nvim' },
        },

        config = function()
            local lsp_zero = require('lsp-zero')
            local lspconfig = require('lspconfig')
            local cmp = require('cmp')

            lsp_zero.set_preferences({
                -- I'll set my own key bindings
                set_lsp_keymaps = false,

                -- I'll manage LSP servers manually using :Mason
                suggest_lsp_servers = false,
            })

            -- Setup LSP key bindings
            lsp_zero.on_attach(function(client, bufnr)
                require('which-key').register({
                    K = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover' },
                    L = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help' },

                    gd = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to Definition' },
                    gD = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to Declaration' },
                    gt = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Go to Type Definition' },
                    gi = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Go to Implementation' },
                    gR = { '<cmd>lua vim.lsp.buf.references()<CR>', 'List References' },

                    ['<localleader>r'] = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
                }, { buffer = bufnr })
            end)

            -- Setup Mason package manager
            require('mason').setup({})

            -- Configure LSP servers installed with Mason
            require('mason-lspconfig').setup({
                ensure_installed = {},

                -- Custom setup for some LSP servers
                handlers = {
                    lsp_zero.default_setup,
                    pylsp = function()
                        lspconfig.pylsp.setup({
                            configurationSources = { 'flake8' },
                        })
                    end,
                },
            })

            -- Setup completion key bindings
            local cmp_action = lsp_zero.cmp_action()
            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<Tab>'] = cmp.mapping.confirm(),
                    ['<C-c>'] = cmp.mapping.close(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                }),
            })

            -- Configure diagnostic key bindings
            require('which-key').register({
                ['[d'] = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Previous Diagnostic' },
                [']d'] = { '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Next Diagnostic' },
            })

            -- Configure LSP diagnostic messages
            vim.diagnostic.config({
                virtual_text = false,
                signs = false,
                underline = true,
                update_in_insert = false,
            })

            -- Show diagnostic message as floating window when hover on line (delay is controlled with `updatetime` option)
            vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]])

            -- Show diagnostics in loclist when they change
            vim.cmd([[autocmd! DiagnosticChanged * lua vim.diagnostic.setloclist({open = false})]])
        end,
    },
}
