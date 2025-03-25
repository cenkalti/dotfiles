-- Show context on top of the window
return {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
        require('treesitter-context').setup({
            multiwindow = true, -- Show context in multiple windows
            multiline_threshold = 1, -- Maximum number of lines to show for a single context
            mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
            max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit
            trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        })
    end,
}
