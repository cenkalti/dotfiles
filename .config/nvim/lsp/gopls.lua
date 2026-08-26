return {
    settings = {
        gopls = {
            gofumpt = true,
            -- Let workspace/symbol reach dependencies and the stdlib, not just the module.
            symbolScope = 'all',
            symbolMatcher = 'fastfuzzy',
        },
    },
}
