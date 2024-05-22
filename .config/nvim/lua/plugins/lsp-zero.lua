return {
    {
        -- https://lsp-zero.netlify.app/v3.x/tutorial.html
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            -- Contains LSP client configurations for various language servers
            { 'neovim/nvim-lspconfig' },
            -- Package manager for LSP servers, linters and formatters
            { 'williamboman/mason.nvim', build = ':MasonUpdate' },
            -- Allows to configure LSP servers using Mason
            --   register a setup hook with lspconfig that ensures servers installed with mason.nvim are set up with the necessary configuration
            --   provide extra convenience APIs such as the :LspInstall command
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'L3MON4D3/LuaSnip' },

            -- Setup key bindings
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

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    -- Setup language servers
                    lsp_zero.default_setup,
                    pylsp = function()
                        local pylsp_opts = lsp_zero.pylsp({
                            configurationSources = { 'flake8' },
                        })
                        lspconfig.pylsp.setup(pylsp_opts)
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
        end,
    },
}
