-- Browse Go package documentation (godoc in a buffer)
return {
    'fredrikaverpil/godoc.nvim',
    version = '*',
    dependencies = {
        { 'nvim-telescope/telescope.nvim' },
        { 'folke/which-key.nvim' },
    },
    build = 'go install github.com/lotusirous/gostdsym/stdsym@latest',
    cmd = 'GoDoc',

    init = function()
        -- Registered from `init`, not `config`: this plugin loads on `:GoDoc`, so a
        -- `config` registration would leave the mapping dead until the first manual
        -- run. `<cmd>GoDoc<CR>` hits lazy's stub command, which loads the plugin.
        require('which-key').add({
            { '<leader>K', '<cmd>GoDoc<CR>', desc = 'Go Docs' },
        })

        -- nvim-treesitter drops and re-requires its parser table on every install,
        -- so out-of-tree parsers have to be re-declared from `User TSUpdate`.
        -- Install/update with :TSInstall godoc or :TSUpdate.
        vim.api.nvim_create_autocmd('User', {
            pattern = 'TSUpdate',
            callback = function()
                require('nvim-treesitter.parsers').godoc = {
                    install_info = {
                        url = 'https://github.com/fredrikaverpil/tree-sitter-godoc',
                        revision = 'd12a20fe9f9b4e9c604937d3e66193c33587b4fd', -- v0.1.0
                    },
                }
            end,
        })

        -- godoc.nvim registers the `godoc` filetype against the `text` language, so
        -- name the parser outright instead of going through the filetype mapping.
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'godoc',
            callback = function(ev)
                pcall(vim.treesitter.start, ev.buf, 'godoc')
            end,
        })
    end,

    config = function()
        require('godoc').setup({
            window = { type = 'vsplit' },
            picker = { type = 'telescope' },
        })

        -- godoc.nvim renders into an unlisted, unnamed scratch buffer, so the page
        -- never reaches :ls or bufferline and cannot be navigated back to. There is
        -- no option for this, so wrap the renderer and promote the buffer it made.
        -- buftype stays `nofile`: the name is not a real path and :w must not try it.
        local godoc = require('godoc')

        -- The picker path always splits before rendering, and its `window.type` only
        -- accepts split/vsplit -- there is no "reuse the current window". Record the
        -- window :GoDoc was called from so the renderer can collapse that split.
        local origin_win
        local dispatch_command = godoc._dispatch_command
        godoc._dispatch_command = function(command, args)
            origin_win = vim.api.nvim_get_current_win()
            return dispatch_command(command, args)
        end

        -- `gd` splits the same way, but its jump is async (it opens a scratch Go file,
        -- waits for gopls, then hands off to telescope), so there is nothing to collapse
        -- afterwards. Undo the split up front and let the whole flow run in the origin
        -- window instead.
        local goto_definition = godoc.goto_definition
        godoc.goto_definition = function(adapter, choice, picker_gotodef_fun)
            local win = vim.api.nvim_get_current_win()
            if origin_win and win ~= origin_win and vim.api.nvim_win_is_valid(origin_win) then
                vim.api.nvim_win_close(win, true)
                vim.api.nvim_set_current_win(origin_win)
            end
            return goto_definition(adapter, choice, picker_gotodef_fun)
        end

        local show_documentation = godoc.show_documentation
        godoc.show_documentation = function(adapter, item)
            local win = vim.api.nvim_get_current_win()
            show_documentation(adapter, item)

            local buf = vim.api.nvim_get_current_buf()
            if origin_win and win ~= origin_win and vim.api.nvim_win_is_valid(origin_win) then
                vim.api.nvim_win_close(win, true)
                vim.api.nvim_win_set_buf(origin_win, buf)
                vim.api.nvim_set_current_win(origin_win)
            end

            local name = 'godoc://' .. item
            for _, other in ipairs(vim.api.nvim_list_bufs()) do
                if other ~= buf and vim.api.nvim_buf_get_name(other):match('godoc://.*$') == name then
                    vim.api.nvim_buf_delete(other, { force = true })
                end
            end
            vim.api.nvim_buf_set_name(buf, name)

            vim.bo[buf].buflisted = true
            vim.bo[buf].bufhidden = ''
            -- `q` stays, but Esc closing a listed buffer's window is too surprising.
            pcall(vim.keymap.del, 'n', '<Esc>', { buffer = buf })
        end
    end,
}
