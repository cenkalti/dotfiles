-- Headless test for lua/go_imports.lua. Run from ~/.config/nvim:
--
--   tests/go_imports/run.sh
--
-- or one mode directly (GO_IMPORTS_LSP=1 for gopls, 0 for the treesitter
-- fallback):
--
--   GO_IMPORTS_LSP=1 nvim --headless -c 'luafile tests/go_imports/run.lua'
--
-- Each case is an import spec as it appears in fixture/main/main.go, written
-- with markup for the expected colour:
--   [name]  green package name; the rest of the spec is string colour
--   D:      whole spec dimmed      (blank import)
--   W:      whole spec warning     (dot import, name not in path)
-- `fallback` is the expectation without gopls; `lsp` is with gopls. They differ
-- only where the path text alone cannot say what the package is called.

local cases = {
    { fallback = '"[fmt]"' },
    { fallback = '"net/[http]"' },
    { fallback = '[stdurl] "net/url"' },
    { fallback = 'D:_ "embed"' },
    { fallback = 'W:. "strings"' },
    { fallback = '"example.com/go-chi/[chi]/v5"' },
    -- Package really is v2: only gopls knows.
    { fallback = '"example.com/api/[autoscaling]/v2"', lsp = '"example.com/api/autoscaling/[v2]"' },
    { fallback = '"gopkg.in/[yaml].v3"' },
    { fallback = '"example.com/mattn/go-[sqlite3]"' },
    -- Declares `package bar`: only gopls knows.
    { fallback = '"example.com/[foo]"', lsp = 'W:"example.com/foo"' },
    { fallback = '"example.com/redis/go-[redis]/v9"' },
    { fallback = '"example.com/opentracing/[opentracing]-go"' },
    { fallback = '"example.com/main/internal/k8s/[v1]"' },
    { fallback = '`[os]`' },
}

local use_lsp = vim.env.GO_IMPORTS_LSP == '1'
local mode = use_lsp and 'gopls' or 'fallback'
local failures = 0

local function out(s)
    io.stdout:write(s, '\n')
end

local function finish()
    out(string.format('%s: %s', mode, failures == 0 and 'PASS' or (failures .. ' FAILED')))
    vim.cmd(failures == 0 and 'qa!' or 'cq!')
end

if not use_lsp then
    vim.lsp.enable('gopls', false)
end
local here = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
vim.cmd.edit(vim.fs.joinpath(here, 'fixture/main/main.go'))
local buf = vim.api.nvim_get_current_buf()

if use_lsp then
    local ok = vim.wait(30000, function()
        return vim.b[buf].go_imports_lsp == true
    end, 50)
    if not ok then
        out('gopls: never produced semantic tokens')
        failures = 1
        return finish()
    end
end
vim.cmd.redraw({ bang = true })

-- Foreground actually drawn at (row, col): the highest-priority highlight
-- layer that sets one (treesitter 100 by default, semantic tokens 125+,
-- extmarks as given; later layers win ties). Headless nvim's screen cells
-- don't carry GUI colours, so read the layers instead.
local function drawn_fg(row, col)
    local info = vim.inspect_pos(buf, row, col, { syntax = false })
    local layers = {}
    for _, cap in ipairs(info.treesitter) do
        -- get_captures_at_pos tests the node range; honour a narrowed one.
        -- Directives store it per capture id: metadata[id].range.
        local r
        for k, v in pairs(cap.metadata or {}) do
            if type(k) == 'number' and type(v) == 'table' and v.range then
                r = v.range
            end
        end
        if not r or (row == r[1] and col >= r[2] and col < r[4]) then
            layers[#layers + 1] = { group = cap.hl_group, prio = tonumber(cap.metadata.priority) or 100 }
        end
    end
    for _, list in ipairs({ info.semantic_tokens, info.extmarks }) do
        for _, m in ipairs(list) do
            if m.opts.hl_group then
                layers[#layers + 1] = { group = m.opts.hl_group, prio = m.opts.priority or 4096 }
            end
        end
    end
    local best, best_prio
    for _, l in ipairs(layers) do
        local c = vim.api.nvim_get_hl(0, { name = l.group, link = false }).fg
        if c and (not best_prio or l.prio >= best_prio) then
            best, best_prio = c, l.prio
        end
    end
    return best
end

local function fg(group)
    return vim.api.nvim_get_hl(0, { name = group, link = false }).fg
end
local colour = {
    name = fg('@module.go'),
    string = fg('@string.go'),
    D = fg('@import.blank.go'),
    W = fg('@import.unknown.go'),
}
local colour_name = {}
for k, v in pairs(colour) do
    colour_name[v] = k
end

local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

for _, case in ipairs(cases) do
    local spec = use_lsp and case.lsp or case.fallback
    local whole = spec:match('^([DW]):')
    local body = whole and spec:sub(3) or spec
    local source = body:gsub('[%[%]]', '')

    -- Expected colour per byte of the spec.
    local want = {}
    if whole then
        for i = 1, #source do
            want[i] = whole
        end
    else
        local inside = false
        for ch in body:gmatch('.') do
            if ch == '[' then
                inside = true
            elseif ch == ']' then
                inside = false
            else
                want[#want + 1] = inside and 'name' or 'string'
            end
        end
    end

    local lnum, start
    for i, l in ipairs(lines) do
        local s, e = l:find(source, 1, true)
        if s and e == #l then
            lnum, start = i, s
            break
        end
    end

    local got, ok = {}, lnum ~= nil
    if lnum then
        for i = 1, #source do
            local ch = source:sub(i, i)
            local c = colour_name[drawn_fg(lnum - 1, start + i - 2)] or '?'
            if ch == ' ' then
                got[i] = ' '
            else
                got[i] = c
                if c ~= want[i] then
                    ok = false
                end
            end
        end
    end

    if ok then
        out('  ok   ' .. spec)
    else
        failures = failures + 1
        local render = {}
        for i = 1, #source do
            render[i] = (got[i] or '?'):sub(1, 1)
        end
        out('  FAIL ' .. spec .. (lnum and ('   got ' .. table.concat(render)) or '   (line not found)'))
        out('       ' .. source)
    end
end

finish()
