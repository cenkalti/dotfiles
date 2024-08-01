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

        -- Temporary fix for following error:
        -- LSP[gopls]: Error SERVER_REQUEST_HANDLER_ERROR:
        -- "...llar/neovim/0.10.0/share/nvim/runtime/lua/vim/_watch.lua:99: ENOENT: no such file or directory"
        -- Issue: https://github.com/neovim/neovim/issues/28058
        -- Fix: https://github.com/SuperAPPKid/astro_nvim_config/commit/3b9d7bb5f68dd468644a8ec4b4f8c716e45d7ae8
        init = function()
            local lsp = vim.lsp
            local make_client_capabilities = lsp.protocol.make_client_capabilities
            function lsp.protocol.make_client_capabilities()
                local caps = make_client_capabilities()
                caps.workspace.didChangeWatchedFiles = nil

                return caps
            end
        end,

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

            local function get_python_path(workspace)
                local path = lspconfig.util.path

                -- Use activated virtualenv.
                if vim.env.VIRTUAL_ENV then
                    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
                end

                -- Find and use virtualenv in workspace directory.
                local match = vim.fn.glob(path.join(workspace, '.venv', 'pyvenv.cfg'))
                if match ~= '' then
                    return path.join(path.dirname(match), 'bin', 'python')
                end

                -- Find and use virtualenv via poetry in workspace directory.
                match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
                if match ~= '' then
                    local venv = vim.fn.trim(vim.fn.system('poetry --directory ' .. workspace .. ' env info -p'))
                    return path.join(venv, 'bin', 'python')
                end

                -- Fallback to system Python.
                return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
            end

            -- Configure LSP servers installed with Mason
            require('mason-lspconfig').setup({
                ensure_installed = {},

                -- Custom setup for some LSP servers
                handlers = {
                    lsp_zero.default_setup,
                    pyright = function()
                        lspconfig.pyright.setup({
                            before_init = function(_, config)
                                config.settings.python.pythonPath = get_python_path(config.root_dir)
                            end,
                        })
                    end,
                    gopls = function()
                        lspconfig.gopls.setup({
                            root_dir = lspconfig.util.root_pattern('go.mod', '.git'),
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
