-- Created with following tutorial:
-- https://lsp-zero.netlify.app/v4.x/tutorial.html
return {
    {
        'neovim/nvim-lspconfig', -- Contains LSP client configurations for various language servers
        dependencies = {
            -- Package manager for LSP servers, linters and formatters
            { 'williamboman/mason.nvim' },

            -- Registers a setup hook with lspconfig that ensures servers installed with mason.nvim
            -- are set up with the necessary configuration
            -- Provides extra convenience APIs such as the :LspInstall command
            { 'williamboman/mason-lspconfig.nvim' },

            -- For key bindings
            { 'folke/which-key.nvim' },

            -- For icons in auto-complete menu
            { 'onsails/lspkind.nvim' },

            -- For auto-completion
            { 'hrsh7th/cmp-nvim-lsp' },
        },

        config = function()
            local lspconfig = require('lspconfig')

            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            local lspconfig_defaults = lspconfig.util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lspconfig_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

            -- This is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local bufnr = event.buf

                    require('which-key').add({
                        { 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', desc = 'Hover', buffer = bufnr },
                        { 'L', '<cmd>lua vim.lsp.buf.signature_help()<CR>', desc = 'Signature Help', buffer = bufnr },
                        { 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', desc = 'Go to Definition', buffer = bufnr },
                        { 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', desc = 'Go to Declaration', buffer = bufnr },
                        {
                            'gt',
                            '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                            desc = 'Go to Type Definition',
                            buffer = bufnr,
                        },
                        {
                            'gi',
                            '<cmd>lua vim.lsp.buf.implementation()<CR>',
                            desc = 'Go to Implementation',
                            buffer = bufnr,
                        },
                        { 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', desc = 'List References', buffer = bufnr },
                        { 'gC', '<cmd>lua vim.lsp.buf.code_action()<CR>', desc = 'Code Action', buffer = bufnr },
                        { '<localleader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', desc = 'Rename', buffer = bufnr },
                    })
                end,
            })

            -- Setup Mason package manager
            require('mason').setup({})

            -- Configure LSP servers installed with Mason
            require('mason-lspconfig').setup({
                ensure_installed = {},

                -- Custom setup for some LSP servers
                handlers = {
                    -- default setup for all LSP servers
                    function(server_name)
                        lspconfig[server_name].setup({})
                    end,

                    -- Custom setup for other LSP servers
                    pyright = function()
                        lspconfig.pyright.setup({
                            root_dir = lspconfig.util.root_pattern('pyproject.toml', '.git'),
                        })
                    end,
                    gopls = function()
                        lspconfig.gopls.setup({
                            root_dir = lspconfig.util.root_pattern('go.mod', '.git'),
                        })
                    end,
                },
            })

            -- Configure LSP diagnostic messages
            vim.diagnostic.config({
                virtual_text = false,
                signs = false,
                underline = true,
                update_in_insert = true,
                float = { source = true },
            })

            -- Show diagnostic message as floating window when hover on line (delay is controlled with `updatetime` option)
            vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]])

            -- Show diagnostics in loclist when they change
            vim.cmd([[autocmd! DiagnosticChanged * lua vim.diagnostic.setloclist({open = false})]])
        end,
    },
}
