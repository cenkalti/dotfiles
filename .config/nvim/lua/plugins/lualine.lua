-- Status line

local function get_function_name(line, node)
    -- Ensure the node is either a function_declaration or method_declaration
    if node:type() ~= 'function_declaration' and node:type() ~= 'method_declaration' then
        return line
    end

    -- Find the identifier child node
    for i = 0, node:child_count() - 1 do
        local child = node:child(i)
        -- For Python
        if child:type() == 'identifier' then
            return vim.treesitter.get_node_text(child, 0)
        end
        -- For Go
        if child:type() == 'field_identifier' then
            return vim.treesitter.get_node_text(child, 0)
        end
    end

    return line
end

local function tree_location()
    return require('nvim-treesitter').statusline({
        type_patterns = { 'function', 'method' },
        transform_fn = get_function_name,
        indicator_size = 40,
    })
end

return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    globalstatus = true,
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '|', right = '|' },
                },
                sections = {
                    lualine_c = { { 'filename', separator = '>' }, { tree_location } },
                    lualine_x = { 'filetype' },
                    lualine_y = {},
                },
            })
        end,
    },
}
