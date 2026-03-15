local wezterm = require('wezterm')

local palette = {
    '#e06c75',
    '#e5c07b',
    '#98c379',
    '#56b6c2',
    '#61afef',
    '#c678dd',
    '#d19a66',
    '#be5046',
    '#46bdcc',
    '#f9a959',
}

local function hash_path(path)
    local h = 5381
    for i = 1, #path do
        h = (h * 33 + string.byte(path, i)) % 0x80000000
    end
    return h
end

local function color_for_path(path)
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

local function setup()
    wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
        local pane = tab.active_pane
        local cwd_uri = pane.current_working_dir
        local cwd = cwd_uri and cwd_uri.file_path or ''

        local title = tab.tab_title ~= '' and tab.tab_title or pane.title
        local label = (tab.tab_index + 1) .. ': ' .. title
        local bg = cwd ~= '' and color_for_path(cwd) or '#555555'

        local active_bg = tab.is_active and bg or dim_color(bg, 0.4)
        local full_fg = fg_for_bg(active_bg)
        local active_fg = tab.is_active and full_fg or blend(full_fg, active_bg, 0.4)

        return {
            { Attribute = { Intensity = tab.is_active and 'Bold' or 'Half' } },
            { Background = { Color = active_bg } },
            { Foreground = { Color = active_fg } },
            { Text = ' ' .. label .. ' ' },
        }
    end)
end

return { setup = setup }
