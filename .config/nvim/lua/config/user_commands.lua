-- vim:foldmethod=marker:foldlevel=0

-- {{{ Open Claude Code in a new WezTerm tab with visual selection and editor context
vim.api.nvim_create_user_command('Claude', function(opts)
    local start_line = opts.line1
    local end_line = opts.line2
    local is_visual = start_line ~= end_line or opts.range == 2

    local current_buf = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_buf)
    local cwd = vim.fn.getcwd()
    local filetype = vim.bo[current_buf].filetype
    local cursor = vim.api.nvim_win_get_cursor(0)

    local function is_real_file_buf(buf)
        return vim.api.nvim_buf_is_loaded(buf)
            and vim.bo[buf].buftype == ''
            and vim.api.nvim_buf_get_name(buf) ~= ''
    end

    -- Collect open buffers, excluding the current one (already shown as Current File)
    local open_buffers = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buf and is_real_file_buf(buf) then
            local rel = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~:.')
            table.insert(open_buffers, rel)
        end
    end

    -- Collect visible splits, excluding the current window
    local current_win = vim.api.nvim_get_current_win()
    local visible_windows = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= current_win then
            local buf = vim.api.nvim_win_get_buf(win)
            if is_real_file_buf(buf) then
                local win_cursor = vim.api.nvim_win_get_cursor(win)
                local rel = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~:.')
                table.insert(visible_windows, string.format('  %s  (line %d)', rel, win_cursor[1]))
            end
        end
    end

    -- Git branch (best-effort, silent on failure)
    local git_branch = vim.fn.system('git -C ' .. vim.fn.shellescape(cwd) .. ' rev-parse --abbrev-ref HEAD 2>/dev/null'):gsub('\n', '')

    -- Build context document
    local parts = {
        '## Neovim Context',
        '',
        'Working directory: ' .. cwd,
    }

    if git_branch ~= '' then
        table.insert(parts, 'Git branch: ' .. git_branch)
    end

    table.insert(parts, '')
    table.insert(parts, '### Current File')
    table.insert(parts, (current_file ~= '' and vim.fn.fnamemodify(current_file, ':~:.') or '(unnamed buffer)'))
    table.insert(parts, 'Filetype: ' .. (filetype ~= '' and filetype or 'unknown'))
    table.insert(parts, 'Cursor position: line ' .. cursor[1] .. ', col ' .. cursor[2] + 1)

    if #open_buffers > 0 then
        table.insert(parts, '')
        table.insert(parts, '### Open Buffers')
        for _, b in ipairs(open_buffers) do
            table.insert(parts, '  ' .. b)
        end
    end

    if #visible_windows > 0 then
        table.insert(parts, '')
        table.insert(parts, '### Visible Windows (splits)')
        for _, w in ipairs(visible_windows) do
            table.insert(parts, w)
        end
    end

    -- Project structure: top-level entries, git-aware when possible
    local structure = vim.fn.system(
        'git -C ' .. vim.fn.shellescape(cwd) .. ' ls-files --others --exclude-standard --cached 2>/dev/null'
        .. ' | awk -F/ \'{print $1}\' | sort -u | head -40'
    ):gsub('\n$', '')
    if structure == '' then
        -- Fallback: plain directory listing
        structure = vim.fn.system('ls -1p ' .. vim.fn.shellescape(cwd) .. ' 2>/dev/null | head -40'):gsub('\n$', '')
    end
    if structure ~= '' then
        table.insert(parts, '')
        table.insert(parts, '### Project Structure')
        for entry in structure:gmatch('[^\n]+') do
            table.insert(parts, '  ' .. entry)
        end
    end

    -- Code snippet: CONTEXT_LINES before and after the selection, selection marked
    local CONTEXT_LINES = 10
    local total_lines   = vim.api.nvim_buf_line_count(current_buf)
    local ctx_start     = math.max(1, start_line - CONTEXT_LINES)
    local ctx_end       = math.min(total_lines, end_line + CONTEXT_LINES)
    local all_lines     = vim.api.nvim_buf_get_lines(current_buf, ctx_start - 1, ctx_end, false)

    -- Label: "line N" for a single line, "lines N–M" for a range
    local selection_label
    if start_line == end_line then
        selection_label = string.format('line %d', start_line)
    else
        selection_label = string.format('lines %d–%d', start_line, end_line)
    end

    local file_label = current_file ~= '' and vim.fn.fnamemodify(current_file, ':~:.') or 'unnamed'
    table.insert(parts, '')
    table.insert(parts, string.format('### %s (%s, selection: %s)',
        is_visual and 'Selected Code' or 'Code at Cursor',
        file_label,
        selection_label))

    local fence = '```' .. (filetype ~= '' and filetype or '')
    table.insert(parts, fence)
    for i, line in ipairs(all_lines) do
        local abs = ctx_start + i - 1
        local prefix = string.format('%4d  ', abs)
        if abs == start_line and abs == end_line then
            table.insert(parts, prefix .. line .. '  ← selected')
        elseif abs == start_line then
            table.insert(parts, prefix .. line .. '  ← selection start')
        elseif abs == end_line then
            table.insert(parts, prefix .. line .. '  ← selection end')
        else
            table.insert(parts, prefix .. line)
        end
    end
    table.insert(parts, '```')
    table.insert(parts, '')

    local context = table.concat(parts, '\n')

    local nvim_server = vim.v.servername
    local mcp_binary  = vim.fn.expand('~/projects/nvim-mcp-bridge/nvim-mcp-bridge')

    local mcp_json = string.format(
        '{"mcpServers":{"nvim-bridge":{"command":"%s","args":["-socket","%s"]}}}',
        mcp_binary, nvim_server
    )

    local spawn_cmd = string.format(
        'wezterm cli spawn --cwd %s -- claude --mcp-config %s --append-system-prompt %s',
        vim.fn.shellescape(cwd),
        vim.fn.shellescape(mcp_json),
        vim.fn.shellescape(context)
    )

    vim.fn.jobstart(spawn_cmd, { detach = true })
    vim.notify('Claude Code opened in new WezTerm tab', vim.log.levels.INFO)
end, {
    range = true,
    desc = 'Open Claude Code in a new WezTerm tab with selection and editor context',
})
-- }}}

-- {{{ Convert tabs to spaces
vim.api.nvim_create_user_command('Tab2Space', function(opts)
    local ts = vim.opt.tabstop:get()
    local range = opts.range
    vim.cmd(string.format('%d,%ds#^\\t\\+#\\=repeat(" ", len(submatch(0))*%d)', range[1], range[2], ts))
end, { range = '%' })
-- }}}

-- {{{ Convert spaces to tabs
vim.api.nvim_create_user_command('Space2Tab', function(opts)
    local ts = vim.opt.tabstop:get()
    local range = opts.range
    vim.cmd(string.format('%d,%ds#^\\( \\{%d}\\)\\+#\\=repeat("\\t", len(submatch(0))/%d)', range[1], range[2], ts, ts))
end, { range = '%' })
-- }}}

-- {{{ Remove trailing whitespace
vim.api.nvim_create_user_command('TrimWhitespace', function()
    vim.cmd([[:%s/\s\+$//e]])
end, { range = '%' })
-- }}}

-- {{{ Replace Unicode dashes and arrows with ASCII equivalents
vim.api.nvim_create_user_command('ASCIIfy', function()
    local replacements = {
        { '[—–−]', '-' },
        { '→', '->' },
        { '←', '<-' },
        { '⇒', '=>' },
        { '⇐', '<=' },
    }
    for _, r in ipairs(replacements) do
        vim.cmd(string.format('%%s/%s/%s/ge', r[1], r[2]))
    end
end, {})
-- }}}
