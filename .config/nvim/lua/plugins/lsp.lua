-- Contains LSP client configurations for various language servers

local function toggle_go_export()
    local word = vim.fn.expand('<cword>')
    if word == '' then
        return
    end

    local first_char = word:sub(1, 1)
    local rest = word:sub(2)
    local new_word

    if first_char:match('[A-Z]') then
        new_word = first_char:lower() .. rest
    elseif first_char:match('[a-z]') then
        new_word = first_char:upper() .. rest
    else
        return
    end

    vim.lsp.buf.rename(new_word)
end

return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'folke/which-key.nvim' },
        },
        config = function()
            -- gopls rejects any document URI whose scheme is not file://, so keep it
            -- off virtual buffers such as fugitive:// blobs. Not calling on_dir means
            -- the client never attaches. A vim.lsp.config() call outranks the
            -- runtimepath lsp/gopls.lua files, so wrap the merged root_dir here
            -- rather than replacing it, and keep lspconfig's module-cache handling.
            local gopls_root_dir = vim.lsp.config.gopls.root_dir
            vim.lsp.config('gopls', {
                root_dir = function(bufnr, on_dir)
                    if vim.api.nvim_buf_get_name(bufnr):match('^%a[%w+.-]*://') then
                        return
                    end
                    gopls_root_dir(bufnr, on_dir)
                end,
            })

            -- This is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local bufnr = event.buf

                    require('which-key').add({
                        { 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', desc = 'Hover', buffer = bufnr },
                        { 'L', '<cmd>lua vim.lsp.buf.signature_help()<CR>', desc = 'Signature Help', buffer = bufnr },
                        { 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', desc = 'Go to Definition', buffer = bufnr },
                        {
                            'gS',
                            '<cmd>split | lua vim.lsp.buf.definition()<CR>',
                            desc = 'Go to Definition (horizontal)',
                            buffer = bufnr,
                        },
                        {
                            'gV',
                            '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>',
                            desc = 'Go to Definition (vertical)',
                            buffer = bufnr,
                        },
                        { 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', desc = 'Go to Declaration', buffer = bufnr },
                        {
                            'gt',
                            '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                            desc = 'Go to Type Definition',
                            buffer = bufnr,
                        },
                        {
                            'gi',
                            '<cmd>lua vim.lsp.buf.implementation()<CR>',
                            desc = 'Go to Implementation',
                            buffer = bufnr,
                        },
                        { 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', desc = 'List References', buffer = bufnr },
                        { 'gC', '<cmd>lua vim.lsp.buf.code_action()<CR>', desc = 'Code Action', buffer = bufnr },
                        { '<localleader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', desc = 'Rename', buffer = bufnr },
                        { '<localleader>e', toggle_go_export, desc = 'Toggle Export', buffer = bufnr },
                    })
                end,
            })
        end,
    },
}
