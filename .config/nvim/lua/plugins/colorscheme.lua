-- Catppuccin color scheme
local M = {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
        -- Highlight custom keywords
        local custom_matches = {
            go = {
                GoPackage = [["[^"]\+\.[^"]\+/.\+"]],
                GoPanic = '\\s*\\<panic\\>',
                GoSelect = '\\s*\\<select\\>$',
                GoContinue = '\\s*\\<continue\\>$',
                GoBreak = '\\s*\\<break\\>$',
                GoFallthrough = '\\s*\\<fallthrough\\>$',
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

        require('catppuccin').setup({
            flavour = 'macchiato',
            dim_inactive = {
                enabled = true,
                shade = 'dark',
                percentage = 0.15,
            },
            custom_highlights = function(colors)
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
                    ['@keyword.conditional.go'] = { fg = colors.overlay2 },
                    ['@punctuation.delimiter.go'] = { fg = colors.overlay2 },
                    ['@punctuation.bracket.go'] = { fg = colors.overlay2 },
                    ['@comment.go'] = { fg = colors.overlay2 },
                    ['@comment.documentation.go'] = { fg = colors.overlay2 },
                    ['@constructor.go'] = { fg = colors.blue },
                    ['@boolean.go'] = { fg = colors.text },
                    ['@number.go'] = { fg = colors.text },
                    ['@property.go'] = { fg = colors.text },
                    ['@field_receiver.go'] = { fg = colors.yellow },

                    -- Python
                    PythonAssert = { fg = colors.overlay2 },
                    ['@lsp.typemod.class.declaration.python'] = { fg = colors.yellow },
                    ['@lsp.typemod.function.declaration.python'] = { fg = colors.blue },
                    ['@constructor.python'] = { fg = colors.blue },
                    ['@keyword.import.python'] = { fg = colors.overlay2 },
                    ['@string.python'] = { fg = colors.overlay2 },
                }
            end,
        })
        vim.cmd.colorscheme('catppuccin')
    end,
}

return M
