-- Completion engine
return {
    'saghen/blink.cmp',
    dependencies = {
        'rafamadriz/friendly-snippets', -- optional: provides snippets for the snippet source
    },
    version = '1.*', -- use a release tag to download pre-built binaries
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        --
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        keymap = { preset = 'default' },

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
