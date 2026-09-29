local wezterm = require('wezterm')

-- Catppuccin Macchiato's 14 accents, to match config.color_scheme. WezTerm's
-- builtin scheme carries only the ANSI slots, not these named accents, so they
-- are spelled out here.
local palette = {
    '#f4dbd6', -- rosewater
    '#f0c6c6', -- flamingo
    '#f5bde6', -- pink
    '#c6a0f6', -- mauve
    '#ed8796', -- red
    '#ee99a0', -- maroon
    '#f5a97f', -- peach
    '#eed49f', -- yellow
    '#a6da95', -- green
    '#8bd5ca', -- teal
    '#91d7e3', -- sky
    '#7dc4e4', -- sapphire
    '#8aadf4', -- blue
    '#b7bdf8', -- lavender
}

local function hash_path(path)
    local h = 5381
    for i = 1, #path do
        h = (h * 33 + string.byte(path, i)) % 0x80000000
    end
    return h
end

local function color_for_path(path)
    path = path:gsub('/+$', '') -- normalize trailing slashes so same dir hashes alike
    return palette[(hash_path(path) % #palette) + 1]
end

local function hex_to_rgb(hex)
    hex = hex:gsub('#', '')
    return {
        r = tonumber(hex:sub(1, 2), 16),
        g = tonumber(hex:sub(3, 4), 16),
        b = tonumber(hex:sub(5, 6), 16),
    }
end

local function relative_luminance(rgb)
    local function linearize(c)
        c = c / 255
        return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
    end
    return 0.2126 * linearize(rgb.r) + 0.7152 * linearize(rgb.g) + 0.0722 * linearize(rgb.b)
end

local function fg_for_bg(hex)
    return relative_luminance(hex_to_rgb(hex)) > 0.179 and '#1e1e2e' or '#ffffff'
end

local function blend(hex_fg, hex_bg, alpha)
    local fg = hex_to_rgb(hex_fg)
    local bg = hex_to_rgb(hex_bg)
    return string.format(
        '#%02x%02x%02x',
        math.floor(fg.r * alpha + bg.r * (1 - alpha)),
        math.floor(fg.g * alpha + bg.g * (1 - alpha)),
        math.floor(fg.b * alpha + bg.b * (1 - alpha))
    )
end

local function dim_color(hex, factor)
    local rgb = hex_to_rgb(hex)
    return string.format(
        '#%02x%02x%02x',
        math.floor(rgb.r * factor),
        math.floor(rgb.g * factor),
        math.floor(rgb.b * factor)
    )
end

-- Whether the agent in a tab is waiting on the user is the harness's question,
-- so work.lua answers it (M.wants_attention); this file only draws the answer.
-- pcall'd so the tab bar still paints on a machine without the harness checkout.
local has_work, work = pcall(require, 'work')

local function wants_attention(pane)
    return has_work and work.wants_attention(pane) or false
end

local function setup()
    wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
        local pane = tab.active_pane
        local vars = pane.user_vars or {}
        local handle = vars.work_handle or ''

        -- The tab names the agent, fully qualified, "@host" and all (INV-20,
        -- INV-28). Never abbreviated: raise tab_max_width rather than let a
        -- handle truncate.
        --
        -- pane.title behind it is the tmux window name arriving as OSC 2,
        -- which for an agent is the adapter ("claude") and so names no one in
        -- particular. It is kept only for a tab holding no agent, where zsh
        -- reports the cwd basename and that is the most useful thing there is.
        local title = handle ~= '' and handle
            or (tab.tab_title ~= '' and tab.tab_title or pane.title)
        local attention = wants_attention(pane)
        local label = (tab.tab_index + 1) .. ' ' .. (attention and '🔔 ' or '') .. title

        -- Colour by agent: the key is the whole handle, "@host" included, so
        -- two agents in one repo get their own hues rather than sharing the
        -- project's. The handle is the one identity signal every agent
        -- carries — a remote agent reports no cwd at all, since its path is on
        -- the far host.
        --
        -- This used to hash the cwd, and then the handle's project prefix
        -- ("harness/pi" -> "harness"), which gave every agent in a repo the
        -- same colour.
        local key = handle
        if key == '' then
            local cwd_uri = pane.current_working_dir
            key = cwd_uri and cwd_uri.file_path or ''
        end
        local bg = key ~= '' and color_for_path(key) or '#555555'

        local active_bg = tab.is_active and bg or dim_color(bg, 0.4)
        local full_fg = fg_for_bg(active_bg)
        -- A tab waiting on you keeps its dimmed background, so it still reads
        -- as not-in-front, but its text is not dimmed: the bell alone is easy
        -- to miss in a row of eight.
        local loud = tab.is_active or attention
        local active_fg = loud and full_fg or blend(full_fg, active_bg, 0.4)

        return {
            { Attribute = { Intensity = loud and 'Bold' or 'Half' } },
            { Background = { Color = active_bg } },
            { Foreground = { Color = active_fg } },
            { Text = ' ' .. label .. ' ' },
        }
    end)
end

return { setup = setup }
