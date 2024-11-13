local lspconfig = require('lspconfig')

local function get_python_path(workspace)
    local path = lspconfig.util.path

    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    -- Find and use virtualenv in workspace directory.
    local match = vim.fn.glob(path.join(workspace, '.venv', 'pyvenv.cfg'))
    if match ~= '' then
        return path.join(path.dirname(match), 'bin', 'python')
    end

    -- Find and use virtualenv via poetry in workspace directory.
    match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
    if match ~= '' then
        local venv = vim.fn.trim(vim.fn.system('poetry --directory ' .. workspace .. ' env info -p'))
        return path.join(venv, 'bin', 'python')
    end

    -- Fallback to system Python.
    return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

return {
    get_python_path = get_python_path,
}
