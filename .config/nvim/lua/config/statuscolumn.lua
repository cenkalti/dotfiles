-- Make the gitsigns gutter mark show on *wrapped* screen rows, not just the
-- first row of a wrapped buffer line.
--
-- Neovim only paints a line's sign on its first screen row (v:virtnum == 0);
-- wrapped continuation rows (v:virtnum > 0) get a blank gutter. This is a core
-- rendering limitation, not a gitsigns bug -- the gitsigns author declined to
-- work around it in the plugin (see gitsigns.nvim discussions #1403, #1408,
-- #1428). A 'statuscolumn' is evaluated for *every* screen row, so we look up
-- the git sign for the underlying buffer line and re-emit it on wrapped rows.
--
-- Diagnostics don't use the sign column here (see config/diagnostic.lua:
-- signs = false), so gitsigns is the only sign source and we can own the whole
-- sign segment for normal file buffers. Special buffers (nvim-tree, pickers,
-- terminals) are left on Neovim's native gutter so their own signs still work.

local M = {}

local STC = "%!v:lua.require'config.statuscolumn'.render()"

-- Highest-priority gitsigns sign extmark on `lnum` (1-based), or nil. gitsigns
-- places its signs as extmarks carrying sign_text / sign_hl_group.
local function git_sign(bufnr, lnum)
    local marks = vim.api.nvim_buf_get_extmarks(
        bufnr, -1, { lnum - 1, 0 }, { lnum - 1, -1 },
        { details = true, type = 'sign' }
    )
    local best
    for _, m in ipairs(marks) do
        local d = m[4]
        if d.sign_text and d.sign_hl_group and d.sign_hl_group:find('GitSigns') then
            if not best or (d.priority or 0) >= (best.priority or 0) then
                best = d
            end
        end
    end
    return best
end

-- Evaluated by 'statuscolumn' once per screen row.
function M.render()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

    -- Sign: shown on the real row (virtnum 0) and wrapped rows (virtnum > 0);
    -- left blank on virtual lines (virtnum < 0, e.g. gitsigns deleted preview).
    local sign = '  '
    if vim.v.virtnum >= 0 then
        local s = git_sign(bufnr, vim.v.lnum)
        if s then
            sign = '%#' .. s.sign_hl_group .. '#' .. s.sign_text .. '%*'
        end
    end

    -- Number: only on the real row, via the native %l item so LineNr /
    -- CursorLineNr highlighting is preserved. Blank on wrapped/virtual rows,
    -- matching the stock behaviour of not repeating the line number.
    local number = vim.v.virtnum == 0 and '%l' or ''

    return sign .. '%=' .. number .. ' '
end

function M.setup()
    -- Apply only to normal file buffers; leave special windows (trees, pickers,
    -- terminals) on Neovim's native gutter so their own signs are untouched.
    local group = vim.api.nvim_create_augroup('wrap_aware_gutter', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufWinEnter', 'FileType', 'TermOpen' }, {
        group = group,
        callback = function(ev)
            vim.wo.statuscolumn = vim.bo[ev.buf].buftype == '' and STC or ''
        end,
    })
end

return M
