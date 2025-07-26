-- Simple Neovim plugin to format command line arguments

local M = {}

-- Tokenize a command line string, respecting quoted arguments
-- Returns a table of tokens extracted from the input line
local function tokenize_command_line(line)
    -- Trim leading and trailing whitespace from the input line
    line = line:gsub('^%s+', ''):gsub('%s+$', '')

    -- Return empty table for empty lines
    if line == '' then
        return {}
    end

    -- Initialize tokenization variables
    local tokens = {}
    local current_token = ''
    local in_quotes = false -- Track if we're inside quoted text
    local quote_char = nil -- Store the opening quote character (' or ")
    local i = 1

    -- Tokenize the line character by character, respecting quoted strings
    while i <= #line do
        local char = line:sub(i, i)

        -- Handle opening quotes (both single and double)
        if not in_quotes and (char == '"' or char == "'") then
            in_quotes = true
            quote_char = char
            current_token = current_token .. char
        -- Handle closing quotes (must match the opening quote type)
        elseif in_quotes and char == quote_char then
            in_quotes = false
            quote_char = nil
            current_token = current_token .. char
        -- Handle spaces outside of quotes as token separators
        elseif not in_quotes and char == ' ' then
            -- Save the current token if it's not empty
            if current_token ~= '' then
                table.insert(tokens, current_token)
                current_token = ''
            end
            -- Skip consecutive spaces to avoid empty tokens
            while i + 1 <= #line and line:sub(i + 1, i + 1) == ' ' do
                i = i + 1
            end
        else
            -- Add regular characters to the current token
            current_token = current_token .. char
        end

        i = i + 1
    end

    -- Don't forget the last token if the line doesn't end with a space
    if current_token ~= '' then
        table.insert(tokens, current_token)
    end

    return tokens
end

-- Function to format a command line string into multi-line format with backslashes
local function format_command_line(line)
    -- Get tokens from the input line
    local tokens = tokenize_command_line(line)

    -- If no tokens were found, return the original line
    if #tokens == 0 then
        return line
    end

    -- Start formatting: first token on its own line with backslash continuation
    local result = { tokens[1] .. ' \\' }

    -- Process remaining tokens, looking for flag-value pairs
    for i = 2, #tokens do
        local token = tokens[i]

        -- Detect long flags (--flag) followed by values (not starting with -)
        -- This groups them on the same line for better readability
        if token:match('^%-%-[^=]+$') and i < #tokens and not tokens[i + 1]:match('^%-') then
            -- Combine flag and value on the same indented line
            result[#result + 1] = '    ' .. token .. ' ' .. tokens[i + 1]
            -- Add backslash continuation if there are more tokens
            if i + 1 < #tokens then
                result[#result] = result[#result] .. ' \\'
            end
            i = i + 1 -- Skip the next token since we just processed it
        else
            -- Handle regular tokens (short flags, commands, standalone values)
            result[#result + 1] = '    ' .. token
            -- Add backslash continuation if there are more tokens
            if i < #tokens then
                result[#result] = result[#result] .. ' \\'
            end
        end
    end

    -- Join all formatted lines with newlines
    return table.concat(result, '\n')
end

-- Main function to format current line or visual selection
-- Handles both normal mode (current line) and visual mode (selected lines)
function M.format_command_line()
    local mode = vim.api.nvim_get_mode().mode

    if mode == 'v' or mode == 'V' then
        -- Visual mode - format all lines in the selection
        local start_line = vim.fn.line("'<") -- Get start of visual selection
        local end_line = vim.fn.line("'>") -- Get end of visual selection

        -- Process each line in the selection
        for line_num = start_line, end_line do
            -- Get the content of the current line
            local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
            local formatted = format_command_line(line)

            -- Split the formatted result into individual lines
            local formatted_lines = vim.split(formatted, '\n')
            -- Replace the original line with the formatted lines
            vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, formatted_lines)

            -- Update end_line to account for added lines (formatted output may be multi-line)
            end_line = end_line + #formatted_lines - 1
        end
    else
        -- Normal mode - format only the current line
        local line_num = vim.api.nvim_win_get_cursor(0)[1] -- Get current cursor line number
        local line = vim.api.nvim_get_current_line() -- Get current line content
        local formatted = format_command_line(line)

        -- Split and replace the current line with formatted content
        local formatted_lines = vim.split(formatted, '\n')
        vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, formatted_lines)
    end
end

-- Setup function to create commands and keymaps
-- Call this function in your Neovim config to initialize the plugin
function M.setup(opts)
    opts = opts or {} -- Use empty table if no options provided

    -- Create the :FormatCommandLine user command
    vim.api.nvim_create_user_command('FormatCommandLine', M.format_command_line, {
        range = true, -- Allow the command to work with visual selections
        desc = 'Format command line arguments',
    })

    -- Set up default keymap unless explicitly disabled
    if opts.keymap ~= false then
        -- Use custom keymap if provided, otherwise default to <localleader>fc
        local keymap = opts.keymap or '<localleader>fc'
        -- Create keymap for both normal and visual modes
        vim.keymap.set({ 'n', 'v' }, keymap, M.format_command_line, {
            desc = 'Format command line arguments',
        })
    end
end

return M
