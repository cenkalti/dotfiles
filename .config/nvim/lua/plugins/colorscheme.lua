-- Catppuccin color scheme
local M = {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
        local flavour = 'macchiato'

        -- Highlight custom keywords
        local custom_matches = {
            go = {
                GoPackage = [["[^"]\+\.[^"]\+/.\+"]],
                GoPanic = '^\\s*\\<panic\\>',
                GoSelect = '^\\s*\\<select\\>',
                GoContinue = '^\\s*\\<continue\\>',
                GoBreak = '^\\s*\\<break\\>',
                GoFallthrough = '^\\s*\\<fallthrough\\>',
                GoChannelReceive = '<-',
                GoChannelSend = '->',
            },
            python = {
                PythonAssert = '\\<assert\\>',
            },
        }
        for filetype, matches in pairs(custom_matches) do
            vim.api.nvim_create_autocmd('FileType', {
                pattern = filetype,
                callback = function()
                    for group, pattern in pairs(matches) do
                        vim.fn.matchadd(group, pattern)
                    end
                end,
            })
        end

        -- Highlight overrides. Every @lsp.* entry here is a semantic-token group
        -- we deliberately keep colored; clear_lsp_hl below blanks every other
        -- @lsp group so treesitter shows through, and derives the keep-set from
        -- this same table so there is no parallel list to maintain.
        local custom_highlights = function(colors)
            return {
                -- Go
                GoPanic = { fg = colors.red },
                GoSelect = { fg = colors.red },
                GoContinue = { fg = colors.red },
                GoBreak = { fg = colors.red },
                GoFallthrough = { fg = colors.red },
                GoPackage = { fg = colors.green },
                GoChannelReceive = { fg = colors.text, bg = colors.red },
                GoChannelSend = { fg = colors.text, bg = colors.red },
                ['@string.go'] = { fg = colors.overlay2 },
                ['@module.go'] = { fg = colors.green },
                ['@lsp.type.namespace.go'] = { fg = colors.green },
                ['@type.go'] = { fg = colors.text },
                ['@type.builtin.go'] = { fg = colors.overlay2 },
                ['@type.definition.go'] = { fg = colors.mauve },
                ['@function.go'] = { fg = colors.blue },
                ['@function.builtin.go'] = { fg = colors.blue },
                ['@function.call.go'] = { fg = colors.blue },
                ['@function.method.go'] = { fg = colors.blue },
                ['@function.method.call.go'] = { fg = colors.blue },
                ['@constant.builtin.go'] = { fg = colors.overlay2 },
                ['@operator.go'] = { fg = colors.overlay2 },
                ['@keyword.go'] = { fg = colors.overlay2 },
                ['@keyword.coroutine.go'] = { fg = colors.red },
                ['@keyword.function.go'] = { fg = colors.overlay2 },
                ['@keyword.type.go'] = { fg = colors.overlay2 },
                ['@keyword.repeat.go'] = { fg = colors.red },
                ['@keyword.return.go'] = { fg = colors.red },
                ['@keyword.import.go'] = { fg = colors.overlay2 },
                ['@variable.parameter.go'] = { fg = colors.text },
                ['@variable.member.go'] = { fg = colors.text },
                ['@lsp.typemod.variable.definition.go'] = { fg = colors.yellow },
                ['@lsp.typemod.parameter.definition.go'] = { fg = colors.yellow },
                ['@keyword.conditional.go'] = { fg = colors.overlay2 },
                ['@punctuation.delimiter.go'] = { fg = colors.overlay2 },
                ['@punctuation.bracket.go'] = { fg = colors.overlay2 },
                ['@comment.go'] = { fg = colors.overlay2, italic = true },
                ['@comment.documentation.go'] = { fg = colors.overlay2, italic = true },
                ['@constructor.go'] = { fg = colors.blue },
                ['@boolean.go'] = { fg = colors.text },
                ['@number.go'] = { fg = colors.text },
                ['@number.float.go'] = { fg = colors.text },
                ['@property.go'] = { fg = colors.text },
                ['@field_receiver.go'] = { fg = colors.peach },

                -- Python
                PythonAssert = { fg = colors.overlay2 },
                ['@constructor.python'] = { fg = colors.blue },
                ['@keyword.import.python'] = { fg = colors.overlay2 },
                ['@string.python'] = { fg = colors.overlay2 },
            }
        end

        require('catppuccin').setup({
            flavour = flavour,
            dim_inactive = {
                enabled = true,
                shade = 'dark',
                percentage = 0.15,
            },
            custom_highlights = custom_highlights,
        })
        vim.cmd.colorscheme('catppuccin')

        -- Make LSP highlights (semantic tokens) paint nothing, letting
        -- treesitter show through. Tokens stay enabled; the groups are blanked,
        -- except the @lsp.* groups colored in custom_highlights above, whose
        -- keys we read back as the keep-set.
        local clear_lsp_hl = function()
            local kept = custom_highlights(require('catppuccin.palettes').get_palette(flavour))
            for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
                if kept[group] == nil then
                    vim.api.nvim_set_hl(0, group, {})
                end
            end
        end
        vim.api.nvim_create_autocmd('ColorScheme', { callback = clear_lsp_hl })
        clear_lsp_hl()

        -- gopls tags a struct-field definition as `variable`+`definition`,
        -- identical to a real variable definition, so field definitions would
        -- inherit the yellow from @lsp.typemod.variable.definition.go above.
        -- Treesitter can still tell them apart: a field name is a
        -- `field_identifier` node, a variable/parameter is a plain `identifier`.
        -- Repaint field definitions back to the normal member color, at a
        -- priority above the semantic token (127) so it wins.
        vim.api.nvim_create_autocmd('LspTokenUpdate', {
            callback = function(args)
                if vim.bo[args.buf].filetype ~= 'go' then return end
                local token = args.data.token
                if token.type ~= 'variable' or not token.modifiers.definition then
                    return
                end
                local ok, node = pcall(vim.treesitter.get_node, {
                    bufnr = args.buf,
                    pos = { token.line, token.start_col },
                })
                if ok and node and node:type() == 'field_identifier' then
                    vim.lsp.semantic_tokens.highlight_token(
                        token, args.buf, args.data.client_id, '@variable.member.go',
                        { priority = vim.hl.priorities.semantic_tokens + 10 }
                    )
                end
            end,
        })
    end,
}

return M
