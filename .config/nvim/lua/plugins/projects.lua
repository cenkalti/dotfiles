-- Switch projects with telescope
-- Directories whose immediate children are projects
local scan_roots = {
    vim.fn.expand('~/projects'),
    vim.fn.expand('~/.config'),
}

-- Individual directories to include as projects directly
local extra_projects = {
    '/opt/homebrew',
}

local history_path = vim.fn.stdpath('data') .. '/project_history.json'

local function read_history()
    local f = io.open(history_path, 'r')
    if not f then
        return {}
    end
    local data = f:read('*a')
    f:close()
    local ok, history = pcall(vim.json.decode, data)
    return ok and history or {}
end

local function write_history(history)
    local f = io.open(history_path, 'w')
    if not f then
        return
    end
    f:write(vim.json.encode(history))
    f:close()
end

local function record_selection(path)
    local history = read_history()
    history[path] = os.time()
    write_history(history)
end

local function discover_projects()
    local projects = {}
    local git_repos = {}

    -- Collect immediate children of scan roots
    for _, root in ipairs(scan_roots) do
        local entries = vim.fn.readdir(root)
        for _, name in ipairs(entries) do
            local path = root .. '/' .. name
            if vim.fn.isdirectory(path) == 1 then
                table.insert(projects, path)
                if vim.fn.isdirectory(path .. '/.git') == 1 or vim.fn.filereadable(path .. '/.git') == 1 then
                    table.insert(git_repos, path)
                end
            end
        end
    end

    -- Fire all git worktree list commands in parallel
    local handles = {}
    for _, repo in ipairs(git_repos) do
        table.insert(handles, {
            repo = repo,
            obj = vim.system({ 'git', '-C', repo, 'worktree', 'list', '--porcelain' }),
        })
    end

    -- Collect results
    for _, h in ipairs(handles) do
        local result = h.obj:wait()
        if result.code == 0 then
            for line in result.stdout:gmatch('[^\n]+') do
                local wt_path = line:match('^worktree (.+)')
                if wt_path and wt_path ~= h.repo then
                    table.insert(projects, wt_path)
                end
            end
        end
    end

    -- Add extra projects
    for _, path in ipairs(extra_projects) do
        table.insert(projects, path)
    end

    -- Deduplicate by path and remove hidden directories
    local seen = {}
    local unique = {}
    for _, path in ipairs(projects) do
        local name = vim.fn.fnamemodify(path, ':t')
        if not seen[path] and name:sub(1, 1) ~= '.' then
            seen[path] = true
            table.insert(unique, path)
        end
    end

    return unique
end

return {
    'nvim-telescope/telescope.nvim',
    keys = {
        {
            '\\w',
            function()
                local pickers = require('telescope.pickers')
                local finders = require('telescope.finders')
                local conf = require('telescope.config').values
                local actions = require('telescope.actions')
                local state = require('telescope.actions.state')
                local builtin = require('telescope.builtin')
                local entry_display = require('telescope.pickers.entry_display')

                local results = discover_projects()
                local history = read_history()
                table.sort(results, function(a, b)
                    return (history[a] or 0) > (history[b] or 0)
                end)

                local displayer = entry_display.create({
                    separator = ' ',
                    items = { { width = 30 }, { remaining = true } },
                })

                pickers
                    .new({}, {
                        prompt_title = 'Projects',
                        finder = finders.new_table({
                            results = results,
                            entry_maker = function(path)
                                local name = vim.fn.fnamemodify(path, ':t')
                                return {
                                    display = function(entry)
                                        return displayer({ entry.name, { entry.value, 'Comment' } })
                                    end,
                                    name = name,
                                    value = path,
                                    ordinal = name .. ' ' .. path,
                                }
                            end,
                        }),
                        previewer = false,
                        sorter = conf.generic_sorter({}),
                        attach_mappings = function(prompt_bufnr)
                            actions.select_default:replace(function()
                                local selected = state.get_selected_entry(prompt_bufnr)
                                if selected == nil then
                                    actions.close(prompt_bufnr)
                                    return
                                end
                                actions._close(prompt_bufnr, true)
                                record_selection(selected.value)
                                vim.cmd.tcd(selected.value)
                                builtin.find_files({ no_ignore = true, hidden = true, follow = true })
                            end)
                            return true
                        end,
                    })
                    :find()
            end,
            desc = 'Switch workspace',
        },
    },
}
