-- Completion engine
return {
    'saghen/blink.cmp',
    dependencies = {
        'rafamadriz/friendly-snippets', -- optional: provides snippets for the snippet source
    },
    version = '1.*', -- use a release tag to download pre-built binaries
    opts = {
        -- Make sure these are in line with Windsurf keybindings
        keymap = {
            preset = 'none',

            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide' },
            ['<C-y>'] = { 'select_and_accept' },

            ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },

            ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

            ['<C-h>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },

        -- Rust fuzzy matcher for typo resistance and significantly better performance
        fuzzy = {
            implementation = 'prefer_rust',
            -- Always prioritize exact matches
            sorts = {
                'exact',
                -- defaults
                'score',
                'sort_text',
            },
        },
    },
}
