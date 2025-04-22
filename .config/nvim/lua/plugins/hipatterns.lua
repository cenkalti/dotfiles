return {
    {
        'echasnovski/mini.hipatterns',
        version = '*',
        config = function()
            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                highlighters = {
                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),

                    -- Highlight Python `assert` statements as comments
                    assert = { pattern = '^%s*assert%s+.*$', group = 'Comment' },
                },
            })
        end,
    },
}
