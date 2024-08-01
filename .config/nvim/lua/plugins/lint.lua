return {
    'mfussenegger/nvim-lint',
    config = function()
        local venv = os.getenv('VIRTUAL_ENV')
        if venv then
            require('lint').linters.mypy.args = { '--config-file', venv .. '/mypy.ini' }
        end

        require('lint').linters_by_ft = {
            markdown = { 'vale' },
            python = { 'flake8' },
        }

        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
            callback = function()
                -- try_lint without arguments runs the linters defined in `linters_by_ft` for the current filetype
                require('lint').try_lint()
            end,
        })
    end,
}
