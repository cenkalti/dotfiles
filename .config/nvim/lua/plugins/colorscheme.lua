-- Catppuccin color scheme
return {
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
                return {
                    -- Reset syntax highlight groups
                    --
                    Normal = { fg = colors.text, bg = colors.base }, -- normal text
                    Character = { fg = colors.text, bg = colors.base }, -- character constants
                    Number = { fg = colors.text, bg = colors.base }, -- numeric constants
                    Boolean = { fg = colors.text, bg = colors.base }, -- boolean constants
                    Float = { fg = colors.text, bg = colors.base }, -- floating point constants
                    Conditional = { fg = colors.text, bg = colors.base }, -- conditional statements (if, else, switch)
                    Repeat = { fg = colors.text, bg = colors.base }, -- loop statements (for, while, do)
                    Label = { fg = colors.text, bg = colors.base }, -- case, default, labels
                    Keyword = { fg = colors.text, bg = colors.base }, -- any other keyword
                    Exception = { fg = colors.text, bg = colors.base }, -- try, catch, throw
                    Include = { fg = colors.text, bg = colors.base }, -- preprocessor #include
                    Define = { fg = colors.text, bg = colors.base }, -- preprocessor #define
                    Macro = { fg = colors.text, bg = colors.base }, -- macro names
                    PreCondit = { fg = colors.text, bg = colors.base }, -- preprocessor conditionals (#if, #ifdef)
                    StorageClass = { fg = colors.text, bg = colors.base }, -- static, register, volatile
                    Structure = { fg = colors.text, bg = colors.base }, -- struct, union, enum
                    Typedef = { fg = colors.text, bg = colors.base }, -- typedef keyword
                    Tag = { fg = colors.text, bg = colors.base }, -- tags that can be used with ctags
                    SpecialChar = { fg = colors.text, bg = colors.base }, -- special character in a constant
                    SpecialComment = { fg = colors.text, bg = colors.base }, -- special comments
                    Debug = { fg = colors.text, bg = colors.base }, -- debugging statements
                    Ignore = { fg = colors.text, bg = colors.base }, -- left blank, hidden
                    Constant = { fg = colors.text, bg = colors.base }, -- any constant
                    Statement = { fg = colors.text, bg = colors.base }, -- any statement
                    PreProc = { fg = colors.text, bg = colors.base }, -- generic preprocessor
                    Type = { fg = colors.text, bg = colors.base }, -- int, long, char, etc.
                    Special = { fg = colors.text, bg = colors.base }, -- any special symbol

                    -- Reset treesitter highlight groups
                    --
                    ['@variable'] = { fg = colors.text, bg = colors.base }, -- various variable names
                    ['@variable.builtin'] = { fg = colors.text, bg = colors.base }, -- built-in variable names (e.g. `this`, `self`)
                    ['@variable.parameter'] = { fg = colors.text, bg = colors.base }, -- parameters of a function
                    ['@variable.parameter.builtin'] = { fg = colors.text, bg = colors.base }, -- special parameters (e.g. `_`, `it`)
                    ['@variable.member'] = { fg = colors.text, bg = colors.base }, -- object and struct fields

                    ['@constant'] = { fg = colors.text, bg = colors.base }, -- constant identifiers
                    ['@constant.builtin'] = { fg = colors.text, bg = colors.base }, -- built-in constant values
                    ['@constant.macro'] = { fg = colors.text, bg = colors.base }, -- constants defined by the preprocessor

                    ['@module'] = { fg = colors.text, bg = colors.base }, -- modules or namespaces
                    ['@module.builtin'] = { fg = colors.text, bg = colors.base }, -- built-in modules or namespaces
                    ['@label'] = { fg = colors.text, bg = colors.base }, -- `GOTO` and other labels (e.g. `label:` in C), including heredoc labels

                    ['@string'] = { fg = colors.text, bg = colors.base }, -- string literals
                    ['@string.documentation'] = { fg = colors.text, bg = colors.base }, -- string documenting code (e.g. Python docstrings)
                    ['@string.regexp'] = { fg = colors.text, bg = colors.base }, -- regular expressions
                    ['@string.escape'] = { fg = colors.text, bg = colors.base }, -- escape sequences
                    ['@string.special'] = { fg = colors.text, bg = colors.base }, -- other special strings (e.g. dates)
                    ['@string.special.symbol'] = { fg = colors.text, bg = colors.base }, -- symbols or atoms
                    ['@string.special.path'] = { fg = colors.text, bg = colors.base }, -- filenames
                    ['@string.special.url'] = { fg = colors.text, bg = colors.base, style = { 'underline' } }, -- URIs (e.g. hyperlinks)

                    ['@character'] = { fg = colors.text, bg = colors.base }, -- character literals
                    ['@character.special'] = { fg = colors.text, bg = colors.base }, -- special characters (e.g. wildcards)

                    ['@boolean'] = { fg = colors.text, bg = colors.base }, -- boolean literals
                    ['@number'] = { fg = colors.text, bg = colors.base }, -- numeric literals
                    ['@number.float'] = { fg = colors.text, bg = colors.base }, -- floating-point number literals

                    ['@type'] = { fg = colors.text, bg = colors.base }, -- type or class definitions and annotations
                    ['@type.builtin'] = { fg = colors.text, bg = colors.base }, -- built-in types
                    ['@type.definition'] = { fg = colors.text, bg = colors.base }, -- identifiers in type definitions (e.g. `typedef <type> <identifier>` in C)

                    ['@attribute'] = { fg = colors.text, bg = colors.base }, -- attribute annotations (e.g. Python decorators, Rust lifetimes)
                    ['@attribute.builtin'] = { fg = colors.text, bg = colors.base }, -- builtin annotations (e.g. `@property` in Python)
                    ['@property'] = { fg = colors.text, bg = colors.base }, -- the key in key/value pairs

                    ['@function'] = { fg = colors.text, bg = colors.base }, -- function definitions
                    ['@function.builtin'] = { fg = colors.text, bg = colors.base }, -- built-in functions
                    ['@function.call'] = { fg = colors.text, bg = colors.base }, -- function calls
                    ['@function.macro'] = { fg = colors.text, bg = colors.base }, -- preprocessor macros

                    ['@function.method'] = { fg = colors.text, bg = colors.base }, -- method definitions
                    ['@function.method.call'] = { fg = colors.text, bg = colors.base }, -- method calls

                    ['@constructor'] = { fg = colors.text, bg = colors.base }, -- constructor calls and definitions
                    ['@operator'] = { fg = colors.text, bg = colors.base }, -- symbolic operators (e.g. `+`, `*`)

                    ['@keyword'] = { fg = colors.text, bg = colors.base }, -- keywords not fitting into specific categories
                    ['@keyword.coroutine'] = { fg = colors.text, bg = colors.base }, -- keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
                    ['@keyword.function'] = { fg = colors.text, bg = colors.base }, -- keywords that define a function (e.g. `func` in Go, `def` in Python)
                    ['@keyword.operator'] = { fg = colors.text, bg = colors.base }, -- operators that are English words (e.g. `and`, `or`)
                    ['@keyword.import'] = { fg = colors.text, bg = colors.base }, -- keywords for including or exporting modules (e.g. `import`, `from` in Python)
                    ['@keyword.type'] = { fg = colors.text, bg = colors.base }, -- keywords describing namespaces and composite types (e.g. `struct`, `enum`)
                    ['@keyword.modifier'] = { fg = colors.text, bg = colors.base }, -- keywords modifying other constructs (e.g. `const`, `static`, `public`)
                    ['@keyword.repeat'] = { fg = colors.text, bg = colors.base }, -- keywords related to loops (e.g. `for`, `while`)
                    ['@keyword.return'] = { fg = colors.text, bg = colors.base }, -- keywords like `return` and `yield`
                    ['@keyword.debug'] = { fg = colors.text, bg = colors.base }, -- keywords related to debugging
                    ['@keyword.exception'] = { fg = colors.text, bg = colors.base }, -- keywords related to exceptions (e.g. `throw`, `catch`)

                    ['@keyword.conditional'] = { fg = colors.text, bg = colors.base }, -- keywords related to conditionals (e.g. `if`, `else`)
                    ['@keyword.conditional.ternary'] = { fg = colors.text, bg = colors.base }, -- ternary operator (e.g. `?`, `:`)

                    ['@keyword.directive'] = { fg = colors.text, bg = colors.base }, -- various preprocessor directives and shebangs
                    ['@keyword.directive.define'] = { fg = colors.text, bg = colors.base }, -- preprocessor definition directives

                    ['@punctuation.delimiter'] = { fg = colors.text, bg = colors.base }, -- delimiters (e.g. `;`, `.`, `,`)
                    ['@punctuation.bracket'] = { fg = colors.text, bg = colors.base }, -- brackets (e.g. `()`, `{}`, `[]`)
                    ['@punctuation.special'] = { fg = colors.text, bg = colors.base }, -- special symbols (e.g. `{}` in string interpolation)

                    ['@comment'] = { fg = colors.text, bg = colors.base }, -- line and block comments
                    ['@comment.documentation'] = { fg = colors.text, bg = colors.base }, -- comments documenting code

                    ['@comment.error'] = { fg = colors.text, bg = colors.base }, -- error-type comments (e.g. `ERROR`, `FIXME`, `DEPRECATED`)
                    ['@comment.warning'] = { fg = colors.text, bg = colors.base }, -- warning-type comments (e.g. `WARNING`, `FIX`, `HACK`)
                    ['@comment.todo'] = { fg = colors.text, bg = colors.base }, -- todo-type comments (e.g. `TODO`, `WIP`)
                    ['@comment.note'] = { fg = colors.text, bg = colors.base }, -- note-type comments (e.g. `NOTE`, `INFO`, `XXX`)

                    ['@markup.strong'] = { fg = colors.text, bg = colors.base, style = { 'bold' } }, -- bold text
                    ['@markup.italic'] = { fg = colors.text, bg = colors.base, style = { 'italic' } }, -- italic text
                    ['@markup.strikethrough'] = { fg = colors.text, bg = colors.base, style = { 'strikethrough' } }, -- struck-through text
                    ['@markup.underline'] = { fg = colors.text, bg = colors.base, style = { 'underline' } }, -- underlined text (only for literal underline markup!)

                    ['@markup.heading'] = { fg = colors.text, bg = colors.base, style = { 'bold' } }, -- headings, titles (including markers)
                    ['@markup.heading.1'] = { fg = colors.text, bg = colors.base, style = { 'bold' } }, -- top-level heading
                    ['@markup.heading.2'] = { fg = colors.text, bg = colors.base, style = { 'bold' } }, -- section heading
                    ['@markup.heading.3'] = { fg = colors.text, bg = colors.base, style = { 'bold' } }, -- subsection heading
                    ['@markup.heading.4'] = { fg = colors.text, bg = colors.base, style = { 'bold' } }, -- and so on
                    ['@markup.heading.5'] = { fg = colors.text, bg = colors.base, style = { 'bold' } }, -- and so forth
                    ['@markup.heading.6'] = { fg = colors.text, bg = colors.base, style = { 'bold' } }, -- six levels ought to be enough for anybody

                    ['@markup.quote'] = { fg = colors.text, bg = colors.base, style = { 'italic' } }, -- block quotes
                    ['@markup.math'] = { fg = colors.text, bg = colors.base }, -- math environments (e.g. `$ ... $` in LaTeX)

                    ['@markup.link'] = { fg = colors.text, bg = colors.base }, -- text references, footnotes, citations, etc.
                    ['@markup.link.label'] = { fg = colors.text, bg = colors.base }, -- link, reference descriptions
                    ['@markup.link.url'] = { fg = colors.text, bg = colors.base, style = { 'underline' } }, -- URL-style links

                    ['@markup.raw'] = { fg = colors.text, bg = colors.base }, -- literal or verbatim text (e.g. inline code)
                    ['@markup.raw.block'] = { fg = colors.text, bg = colors.base }, -- literal or verbatim text as a stand-alone block

                    ['@markup.list'] = { fg = colors.text, bg = colors.base }, -- list markers
                    ['@markup.list.checked'] = { fg = colors.text, bg = colors.base }, -- checked todo-style list markers
                    ['@markup.list.unchecked'] = { fg = colors.text, bg = colors.base }, -- unchecked todo-style list markers

                    ['@diff.plus'] = { fg = colors.text, bg = colors.base }, -- added text (for diff files)
                    ['@diff.minus'] = { fg = colors.text, bg = colors.base }, -- deleted text (for diff files)
                    ['@diff.delta'] = { fg = colors.text, bg = colors.base }, -- changed text (for diff files)

                    ['@tag'] = { fg = colors.text, bg = colors.base }, -- XML-style tag names (e.g. in XML, HTML, etc.)
                    ['@tag.builtin'] = { fg = colors.text, bg = colors.base }, -- builtin tag names (e.g. HTML5 tags)
                    ['@tag.attribute'] = { fg = colors.text, bg = colors.base }, -- XML-style tag attributes
                    ['@tag.delimiter'] = { fg = colors.text, bg = colors.base }, -- XML-style tag delimiters

                    -- Go overrides
                    --
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

                    -- Python overrides
                    --
                    ['@lsp.typemod.class.declaration.python'] = { fg = colors.yellow }, -- Python type modifiers
                }
            end,
        })
        vim.cmd.colorscheme('catppuccin')

        -- Highlight panic keyword in Go files
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'go',
            callback = function()
                vim.fn.matchadd('GoPanic', '\\<panic\\>')
                vim.fn.matchadd('GoSelect', '\\<select\\>')
            end,
        })
    end,
}
