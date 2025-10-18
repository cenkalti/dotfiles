-- Catppuccin color scheme
local M = {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
        require('catppuccin').setup({
            flavour = 'macchiato',
            dim_inactive = {
                enabled = true,
                shade = 'dark',
                percentage = 0.15,
            },
            custom_highlights = function(colors)
                local hi = {}

                -- Reset existing highlights
                for _, group in ipairs(BUILTIN_GROUPS) do
                    hi[group] = { fg = colors.text, bg = colors.base }
                end
                for _, group in ipairs(TREESITTER_GROUPS) do
                    hi[group] = { fg = colors.text, bg = colors.base }
                end

                -- Language-specific overrides
                for group, spec in pairs(GO_OVERRIDES(colors)) do
                    hi[group] = spec
                end
                for group, spec in pairs(PYTHON_OVERRIDES(colors)) do
                    hi[group] = spec
                end

                return hi
            end,
        })
        vim.cmd.colorscheme('catppuccin')

        -- Highlight custom keywords
        for filetype, matches in pairs(CUSTOM_MATCHES) do
            vim.api.nvim_create_autocmd('FileType', {
                pattern = filetype,
                callback = function()
                    for group, pattern in pairs(matches) do
                        vim.fn.matchadd(group, pattern)
                    end
                end,
            })
        end
    end,
}

-- Full list can be found here:
-- https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c
BUILTIN_GROUPS = {
    'Normal', -- normal text
    'Character', -- character constants
    'Number', -- numeric constants
    'Boolean', -- boolean constants
    'Float', -- floating point constants
    'Conditional', -- conditional statements (if, else, switch)
    'Repeat', -- loop statements (for, while, do)
    'Label', -- case, default, labels
    'Keyword', -- any other keyword
    'Exception', -- try, catch, throw
    'Include', -- preprocessor #include
    'Define', -- preprocessor #define
    'Macro', -- macro names
    'PreCondit', -- preprocessor conditionals (#if, #ifdef)
    'StorageClass', -- static, register, volatile
    'Structure', -- struct, union, enum
    'Typedef', -- typedef keyword
    'Tag', -- tags that can be used with ctags
    'SpecialChar', -- special character in a constant
    'SpecialComment', -- special comments
    'Debug', -- debugging statements
    'Ignore', -- left blank, hidden
    'Constant', -- any constant
    'Statement', -- any statement
    'PreProc', -- generic preprocessor
    'Type', -- int, long, char, etc.
    'Special', -- any special symbol
}

-- Full list can be found here:
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights
TREESITTER_GROUPS = {
    '@variable', -- various variable names
    '@variable.builtin', -- built-in variable names (e.g. `this`, `self`)
    '@variable.parameter', -- parameters of a function
    '@variable.parameter.builtin', -- special parameters (e.g. `_`, `it`)
    '@variable.member', -- object and struct fields

    '@constant', -- constant identifiers
    '@constant.builtin', -- built-in constant values
    '@constant.macro', -- constants defined by the preprocessor

    '@module', -- modules or namespaces
    '@module.builtin', -- built-in modules or namespaces
    '@label', -- `GOTO` and other labels (e.g. `label:` in C), including heredoc labels

    '@string', -- string literals
    '@string.documentation', -- string documenting code (e.g. Python docstrings)
    '@string.regexp', -- regular expressions
    '@string.escape', -- escape sequences
    '@string.special', -- other special strings (e.g. dates)
    '@string.special.symbol', -- symbols or atoms
    '@string.special.path', -- filenames
    '@string.special.url', -- URIs (e.g. hyperlinks)

    '@character', -- character literals
    '@character.special', -- special characters (e.g. wildcards)

    '@boolean', -- boolean literals
    '@number', -- numeric literals
    '@number.float', -- floating-point number literals

    '@type', -- type or class definitions and annotations
    '@type.builtin', -- built-in types
    '@type.definition', -- identifiers in type definitions (e.g. `typedef <type> <identifier>` in C)

    '@attribute', -- attribute annotations (e.g. Python decorators, Rust lifetimes)
    '@attribute.builtin', -- builtin annotations (e.g. `@property` in Python)
    '@property', -- the key in key/value pairs

    '@function', -- function definitions
    '@function.builtin', -- built-in functions
    '@function.call', -- function calls
    '@function.macro', -- preprocessor macros

    '@function.method', -- method definitions
    '@function.method.call', -- method calls

    '@constructor', -- constructor calls and definitions
    '@operator', -- symbolic operators (e.g. `+`, `*`)

    '@keyword', -- keywords not fitting into specific categories
    '@keyword.coroutine', -- keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
    '@keyword.function', -- keywords that define a function (e.g. `func` in Go, `def` in Python)
    '@keyword.operator', -- operators that are English words (e.g. `and`, `or`)
    '@keyword.import', -- keywords for including or exporting modules (e.g. `import`, `from` in Python)
    '@keyword.type', -- keywords describing namespaces and composite types (e.g. `struct`, `enum`)
    '@keyword.modifier', -- keywords modifying other constructs (e.g. `const`, `static`, `public`)
    '@keyword.repeat', -- keywords related to loops (e.g. `for`, `while`)
    '@keyword.return', -- keywords like `return` and `yield`
    '@keyword.debug', -- keywords related to debugging
    '@keyword.exception', -- keywords related to exceptions (e.g. `throw`, `catch`)

    '@keyword.conditional', -- keywords related to conditionals (e.g. `if`, `else`)
    '@keyword.conditional.ternary', -- ternary operator (e.g. `?`, `:`)

    '@keyword.directive', -- various preprocessor directives and shebangs
    '@keyword.directive.define', -- preprocessor definition directives

    '@punctuation.delimiter', -- delimiters (e.g. `;`, `.`, `,`)
    '@punctuation.bracket', -- brackets (e.g. `()`, `{}`, `[]`)
    '@punctuation.special', -- special symbols (e.g. `{}` in string interpolation)

    '@comment', -- line and block comments
    '@comment.documentation', -- comments documenting code

    '@comment.error', -- error-type comments (e.g. `ERROR`, `FIXME`, `DEPRECATED`)
    '@comment.warning', -- warning-type comments (e.g. `WARNING`, `FIX`, `HACK`)
    '@comment.todo', -- todo-type comments (e.g. `TODO`, `WIP`)
    '@comment.note', -- note-type comments (e.g. `NOTE`, `INFO`, `XXX`)

    '@markup.strong', -- bold text
    '@markup.italic', -- italic text
    '@markup.strikethrough', -- struck-through text
    '@markup.underline', -- underlined text (only for literal underline markup!)

    '@markup.heading', -- headings, titles (including markers)
    '@markup.heading.1', -- top-level heading
    '@markup.heading.2', -- section heading
    '@markup.heading.3', -- subsection heading
    '@markup.heading.4', -- and so on
    '@markup.heading.5', -- and so forth
    '@markup.heading.6', -- six levels ought to be enough for anybody

    '@markup.quote', -- block quotes
    '@markup.math', -- math environments (e.g. `$ ... $` in LaTeX)

    '@markup.link', -- text references, footnotes, citations, etc.
    '@markup.link.label', -- link, reference descriptions
    '@markup.link.url', -- URL-style links

    '@markup.raw', -- literal or verbatim text (e.g. inline code)
    '@markup.raw.block', -- literal or verbatim text as a stand-alone block

    '@markup.list', -- list markers
    '@markup.list.checked', -- checked todo-style list markers
    '@markup.list.unchecked', -- unchecked todo-style list markers

    '@diff.plus', -- added text (for diff files)
    '@diff.minus', -- deleted text (for diff files)
    '@diff.delta', -- changed text (for diff files)

    '@tag', -- XML-style tag names (e.g. in XML, HTML, etc.)
    '@tag.builtin', -- builtin tag names (e.g. HTML5 tags)
    '@tag.attribute', -- XML-style tag attributes
    '@tag.delimiter', -- XML-style tag delimiters
}

function GO_OVERRIDES(colors)
    return {
        ['@string.go'] = { fg = colors.overlay2 },
        ['@module.go'] = { fg = colors.green }, -- modules or namespaces
        ['@type.builtin.go'] = { fg = colors.overlay2 }, -- built-in types
        ['@type.definition.go'] = { fg = colors.mauve }, -- identifiers in type definitions (e.g. `typedef <type> <identifier>` in C)
        ['@function.go'] = { fg = colors.blue }, -- function definitions
        ['@function.builtin.go'] = { fg = colors.blue }, -- built-in functions
        ['@function.call.go'] = { fg = colors.blue }, -- function calls
        ['@function.method.go'] = { fg = colors.blue }, -- method definitions
        ['@function.method.call.go'] = { fg = colors.blue }, -- method calls
        ['@operator.go'] = { fg = colors.overlay2 }, -- symbolic operators (e.g. `+`, `*`)
        ['@keyword.go'] = { fg = colors.overlay2 }, -- keywords not fitting into specific categories
        ['@keyword.coroutine.go'] = { fg = colors.red }, -- keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
        ['@keyword.function.go'] = { fg = colors.overlay2 }, -- keywords that define a function (e.g. `func` in Go, `def` in Python)
        ['@keyword.type.go'] = { fg = colors.overlay2 }, -- keywords describing namespaces and composite types (e.g. `struct`, `enum`)
        ['@keyword.repeat.go'] = { fg = colors.red }, -- keywords related to loops (e.g. `for`, `while`)
        ['@keyword.return.go'] = { fg = colors.red }, -- keywords like `return` and `yield`
        ['@keyword.conditional.go'] = { fg = colors.overlay2 }, -- keywords related to conditionals (e.g. `if`, `else`)
        ['@punctuation.delimiter.go'] = { fg = colors.overlay2 }, -- delimiters (e.g. `;`, `.`, `,`)
        ['@punctuation.bracket.go'] = { fg = colors.overlay2 }, -- brackets (e.g. `()`, `{}`, `[]`)
        ['@comment.go'] = { fg = colors.yellow }, -- line and block comments
        ['@comment.documentation.go'] = { fg = colors.overlay2 }, -- comments documenting code
        GoPanic = { fg = colors.red }, -- panic keyword in Go
        GoSelect = { fg = colors.red }, -- select keyword in Go
    }
end

function PYTHON_OVERRIDES(colors)
    return {
        ['@lsp.typemod.class.declaration.python'] = { fg = colors.yellow },
        ['@lsp.typemod.function.declaration.python'] = { fg = colors.blue },
        ['@constructor.python'] = { fg = colors.blue },
        ['@keyword.import.python'] = { fg = colors.overlay2 },

        -- rest is copied from go
        ['@string.python'] = { fg = colors.overlay2 },
        ['@module.python'] = { fg = colors.green },
        ['@type.builtin.python'] = { fg = colors.overlay2 },
        ['@type.definition.python'] = { fg = colors.mauve },
        ['@function.python'] = { fg = colors.blue },
        ['@function.builtin.python'] = { fg = colors.blue },
        ['@function.call.python'] = { fg = colors.blue },
        ['@function.method.python'] = { fg = colors.blue },
        ['@function.method.call.python'] = { fg = colors.blue },
        ['@operator.python'] = { fg = colors.overlay2 },
        ['@keyword.python'] = { fg = colors.overlay2 },
        ['@keyword.coroutine.python'] = { fg = colors.red },
        ['@keyword.function.python'] = { fg = colors.overlay2 },
        ['@keyword.type.python'] = { fg = colors.overlay2 },
        ['@keyword.repeat.python'] = { fg = colors.red },
        ['@keyword.return.python'] = { fg = colors.red },
        ['@keyword.conditional.python'] = { fg = colors.overlay2 },
        ['@punctuation.delimiter.python'] = { fg = colors.overlay2 },
        ['@punctuation.bracket.python'] = { fg = colors.overlay2 },
        ['@comment.python'] = { fg = colors.yellow },
        ['@comment.documentation.python'] = { fg = colors.overlay2 },
    }
end

-- Custom keyword matches per filetype
CUSTOM_MATCHES = {
    go = {
        GoPanic = '\\<panic\\>',
        GoSelect = '\\<select\\>',
    },
}

return M
