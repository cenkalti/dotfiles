-- https://www.reddit.com/r/neovim/comments/1ogppda/comment/nll6ulu/
vim.treesitter.query.add_predicate('is-go-field-receiver?', function(match, pattern, source, predicate, metadata)
    local field_id = predicate[2]
    local field = match[field_id][1]

    local operand_id = predicate[3]
    local operand = match[operand_id][1]

    ---@type TSNode
    local current = field
    while current and current:type() ~= 'method_declaration' do
        current = current:parent()
    end
    if not current then
        return false
    end
    local method_declaration = current

    local receiver_parameter_list = method_declaration:field('receiver')[1]
    if not receiver_parameter_list then
        return false
    end

    local receiver_parameter_declaration = receiver_parameter_list:named_child(0)
    if not receiver_parameter_declaration then
        return false
    end

    local receiver_name = receiver_parameter_declaration:field('name')[1]
    if not receiver_name then
        return false
    end

    local receiver_name_text = vim.treesitter.get_node_text(receiver_name, source)
    local operand_text = vim.treesitter.get_node_text(operand, source)

    return receiver_name_text == operand_text
end, { force = true })
