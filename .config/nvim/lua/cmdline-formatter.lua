-- cmdline-formatter.lua
-- Simple Neovim plugin to format command line arguments

local M = {}

-- Function to format a command line string
local function format_cmdline(line)
    -- Trim whitespace
    line = line:gsub('^%s+', ''):gsub('%s+$', '')

    if line == '' then
        return line
    end

    local tokens = {}
    local current_token = ''
    local in_quotes = false
    local quote_char = nil
    local i = 1

    -- Tokenize the line respecting quotes
    while i <= #line do
        local char = line:sub(i, i)

        if not in_quotes and (char == '"' or char == "'") then
            in_quotes = true
            quote_char = char
            current_token = current_token .. char
        elseif in_quotes and char == quote_char then
            in_quotes = false
            quote_char = nil
            current_token = current_token .. char
        elseif not in_quotes and char == ' ' then
            if current_token ~= '' then
                table.insert(tokens, current_token)
                current_token = ''
            end
            -- Skip multiple spaces
            while i + 1 <= #line and line:sub(i + 1, i + 1) == ' ' do
                i = i + 1
            end
        else
            current_token = current_token .. char
        end

        i = i + 1
    end

    -- Add the last token if it exists
    if current_token ~= '' then
        table.insert(tokens, current_token)
    end

    if #tokens == 0 then
        return line
    end

    -- Format the tokens
    local result = { tokens[1] .. ' \\' }

    for j = 2, #tokens do
        local token = tokens[j]

        -- Check if this token and the next form a flag-value pair
        if token:match('^%-%-[^=]+$') and j < #tokens and not tokens[j + 1]:match('^%-') then
            -- This is a flag followed by a value
            result[#result + 1] = '    ' .. token .. ' ' .. tokens[j + 1]
            if j + 1 < #tokens then
                result[#result] = result[#result] .. ' \\'
            end
            j = j + 1 -- Skip the next token since we processed it
        else
            -- Regular token
            result[#result + 1] = '    ' .. token
            if j < #tokens then
                result[#result] = result[#result] .. ' \\'
            end
        end
    end

    return table.concat(result, '\n')
end

-- Main function to format current line or visual selection
function M.format_cmdline()
    local mode = vim.api.nvim_get_mode().mode

    if mode == 'v' or mode == 'V' then
        -- Visual mode - format selected lines
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")

        for line_num = start_line, end_line do
            local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
            local formatted = format_cmdline(line)

            -- Replace the line with formatted content
            local formatted_lines = vim.split(formatted, '\n')
            vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, formatted_lines)

            -- Adjust end_line if we added lines
            end_line = end_line + #formatted_lines - 1
        end
    else
        -- Normal mode - format current line
        local line_num = vim.api.nvim_win_get_cursor(0)[1]
        local line = vim.api.nvim_get_current_line()
        local formatted = format_cmdline(line)

        -- Replace current line with formatted content
        local formatted_lines = vim.split(formatted, '\n')
        vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, formatted_lines)
    end
end

-- Setup function to create commands and keymaps
function M.setup(opts)
    opts = opts or {}

    -- Create user command
    vim.api.nvim_create_user_command('FormatCmdline', M.format_cmdline, {
        range = true,
        desc = 'Format command line arguments',
    })

    -- Set up default keymap if not disabled
    if opts.keymap ~= false then
        local keymap = opts.keymap or '<localleader>fc'
        vim.keymap.set({ 'n', 'v' }, keymap, M.format_cmdline, {
            desc = 'Format command line arguments',
        })
    end
end

return M
