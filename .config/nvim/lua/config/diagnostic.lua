-- Configure LSP diagnostic messages
vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = true,
    update_in_insert = false,
    float = {
        source = true,
        border = 'rounded',
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter' },
    },
})

-- Show diagnostic message as floating window when hover on line (delay is controlled with `updatetime` option)
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float({focusable=false})]])