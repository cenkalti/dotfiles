-- Go import highlighting: colour exactly the name the import binds in the file.
--
--   alias "path"         -> the alias            (treesitter @module)
--   _ "path"             -> whole spec dimmed    (@import.blank)
--   . "path"             -> whole spec warning   (@import.dot)
--   "path"               -> the package name inside the path
--
-- For an unaliased path the package name comes from gopls, whose semantic
-- tokens mark the real name inside the string (yaml in "gopkg.in/yaml.v3",
-- sqlite3 in ".../go-sqlite3", v2 in "k8s.io/api/autoscaling/v2"). If gopls
-- marks nothing, the declared package name is absent from the path, and the
-- spec is painted as a warning (@import.unknown).
--
-- Until gopls has answered for a buffer, a treesitter fallback guesses the
-- name from the path text (see M.fallback_range). Once gopls has answered,
-- the fallback switches off so the two can never colour different segments.

local M = {}

local ns = vim.api.nvim_create_namespace('go_imports')

--- Byte range [s, e) of the guessed package name inside an import path.
---@param path string import path without quotes
---@return integer s, integer e 0-based start, exclusive end
function M.fallback_range(path)
    local segs, starts = {}, {}
    local pos = 1
    for seg in (path .. '/'):gmatch('([^/]*)/') do
        segs[#segs + 1], starts[#starts + 1] = seg, pos
        pos = pos + #seg + 1
    end
    local i = #segs
    -- Module major-version suffix: ".../chi/v5" is package chi. v1 is never a
    -- suffix, so ".../core/v1" stays v1.
    local major = tonumber(segs[i]:match('^v(%d+)$'))
    if i > 1 and major and major >= 2 then
        i = i - 1
    end
    local seg, s, e = segs[i], 1, #segs[i]
    local stem = seg:match('^(.-)%.v%d+$') -- gopkg.in/yaml.v3
    if stem and stem ~= '' then
        e = #stem
    end
    for _, prefix in ipairs({ 'golang-', 'go-' }) do
        if e > #prefix and seg:sub(1, #prefix) == prefix then
            s = #prefix + 1
            break
        end
    end
    if e - s + 1 > 3 and seg:sub(e - 2, e) == '-go' then
        e = e - 3
    end
    return starts[i] - 1 + s - 1, starts[i] - 1 + e
end

-- Treesitter fallback: active only until gopls has answered for the buffer.
vim.treesitter.query.add_predicate('go-import-fallback?', function(_, _, source)
    return type(source) ~= 'number' or not vim.b[source].go_imports_lsp
end, { force = true })

-- Narrow the captured string literal to the guessed package name.
vim.treesitter.query.add_directive('go-import-name!', function(match, _, source, pred, metadata)
    local id = pred[2]
    local node = match[id] and match[id][1]
    if not node then
        return
    end
    local text = vim.treesitter.get_node_text(node, source)
    local sr, sc, er = node:range()
    if sr ~= er or #text < 2 then
        return
    end
    local s, e = M.fallback_range(text:sub(2, -2))
    metadata[id] = metadata[id] or {}
    metadata[id].range = { sr, sc + 1 + s, sr, sc + 1 + e }
end, { force = true })

local unaliased = vim.treesitter.query.parse('go', '(import_spec !name path: (_) @path) @spec')

--- Re-read gopls tokens and mark unaliased imports whose name gopls did not find.
---@param buf integer
local function refresh(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
        return
    end
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local ok, parser = pcall(vim.treesitter.get_parser, buf, 'go')
    if not ok or not parser then
        return
    end
    local root = parser:parse()[1]:root()
    for _, match in unaliased:iter_matches(root, buf) do
        local path, spec
        for id, nodes in pairs(match) do
            if unaliased.captures[id] == 'path' then
                path = nodes[1]
            else
                spec = nodes[1]
            end
        end
        local row, sc, _, ec = path:range()
        local named = false
        for col = sc + 1, ec - 2 do
            for _, tok in ipairs(vim.lsp.semantic_tokens.get_at_pos(buf, row, col) or {}) do
                if tok.type == 'namespace' then
                    named = true
                    break
                end
            end
            if named then
                break
            end
        end
        if not named then
            local r1, c1, r2, c2 = spec:range()
            vim.api.nvim_buf_set_extmark(buf, ns, r1, c1, {
                end_row = r2,
                end_col = c2,
                hl_group = '@import.unknown.go',
                priority = vim.hl.priorities.semantic_tokens + 10,
            })
        end
    end
    vim.b[buf].go_imports_lsp = true
    vim.api.nvim__redraw({ buf = buf, valid = false })
end

local pending = {}

local group = vim.api.nvim_create_augroup('go_imports', { clear = true })

-- Fires for each newly drawn token of a fresh gopls result; batch them.
vim.api.nvim_create_autocmd('LspTokenUpdate', {
    group = group,
    callback = function(args)
        if vim.bo[args.buf].filetype ~= 'go' or pending[args.buf] then
            return
        end
        pending[args.buf] = true
        vim.schedule(function()
            pending[args.buf] = nil
            refresh(args.buf)
        end)
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= 'gopls' or not vim.api.nvim_buf_is_valid(args.buf) then
            return
        end
        vim.b[args.buf].go_imports_lsp = nil
        vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)
    end,
})

return M
