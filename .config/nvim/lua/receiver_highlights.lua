local M = {}

-- Store namespace for our custom highlights
M.ns = vim.api.nvim_create_namespace('receiver_fields')

-- Get all receiver names from method declarations
local function get_receiver_names_from_methods(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, 'go')
    if not parser then
        return {}
    end

    local tree = parser:parse()[1]
    local root = tree:root()

    local query = vim.treesitter.query.parse(
        'go',
        [[
    (method_declaration
      receiver: (parameter_list
        (parameter_declaration
          name: (identifier) @receiver_name))
      body: (block) @body)
  ]]
    )

    local receiver_scopes = {}

    for id, node in query:iter_captures(root, bufnr) do
        local capture_name = query.captures[id]

        if capture_name == 'receiver_name' then
            local receiver_name = vim.treesitter.get_node_text(node, bufnr)
            local parent = node:parent()

            -- Find the method body
            while parent and parent:type() ~= 'method_declaration' do
                parent = parent:parent()
            end

            if parent then
                for child in parent:iter_children() do
                    if child:type() == 'block' then
                        local start_row, _, end_row, _ = child:range()
                        receiver_scopes[#receiver_scopes + 1] = {
                            name = receiver_name,
                            start_row = start_row,
                            end_row = end_row,
                        }
                        break
                    end
                end
            end
        end
    end

    return receiver_scopes
end

local function highlight_receiver_fields_simple(bufnr)
    local receiver_scopes = get_receiver_names_from_methods(bufnr)
    if #receiver_scopes == 0 then
        return
    end

    local parser = vim.treesitter.get_parser(bufnr, 'go')
    if not parser then
        return
    end

    local tree = parser:parse()[1]
    local root = tree:root()

    -- Query for selector expressions that are NOT method calls
    local query = vim.treesitter.query.parse(
        'go',
        [[
    (selector_expression
      operand: (identifier) @operand
      field: (field_identifier) @field)
  ]]
    )

    -- Clear previous highlights
    vim.api.nvim_buf_clear_namespace(bufnr, M.ns, 0, -1)

    for id, node in query:iter_captures(root, bufnr) do
        local capture_name = query.captures[id]

        if capture_name == 'operand' then
            local operand_name = vim.treesitter.get_node_text(node, bufnr)
            local row = node:start()

            -- Check if this operand is a receiver in the current scope
            for _, scope in ipairs(receiver_scopes) do
                if operand_name == scope.name and row >= scope.start_row and row <= scope.end_row then
                    local parent = node:parent()
                    if parent then
                        -- Check if the selector_expression is part of a call_expression
                        local grandparent = parent:parent()
                        local is_method_call = grandparent and grandparent:type() == 'call_expression'

                        if not is_method_call then
                            -- This is a field access, not a method call
                            for child in parent:iter_children() do
                                if child:type() == 'field_identifier' then
                                    local field_row, field_col = child:start()
                                    local _, field_end_col = child:end_()

                                    vim.api.nvim_buf_add_highlight(
                                        bufnr,
                                        M.ns,
                                        'GoReceiverField',
                                        field_row,
                                        field_col,
                                        field_end_col
                                    )
                                    break
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
    end
end

-- Set up autocommands to refresh highlights
function M.setup()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'InsertLeave' }, {
        pattern = '*.go',
        callback = function(args)
            local bufnr = args.buf

            -- Use the simpler treesitter-only approach (filters out method calls)
            vim.schedule(function()
                highlight_receiver_fields_simple(bufnr)
            end)
        end,
    })

    -- Also refresh on LSP attach
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            if vim.bo[args.buf].filetype == 'go' then
                vim.schedule(function()
                    highlight_receiver_fields_simple(args.buf)
                end)
            end
        end,
    })

    -- Initial highlight for current buffer
    if vim.bo.filetype == 'go' then
        highlight_receiver_fields_simple(0)
    end
end

-- Call setup
M.setup()

return M
