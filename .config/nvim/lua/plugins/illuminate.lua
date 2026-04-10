-- Highlight word under cursor via LSP document highlights

local group = vim.api.nvim_create_augroup('WordHighlight', { clear = true })

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = group,
    callback = function()
        local clients = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/documentHighlight' })
        if #clients > 0 then
            vim.lsp.buf.document_highlight()
        end
    end,
})

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = group,
    callback = function()
        vim.lsp.buf.clear_references()
    end,
})

return {}
