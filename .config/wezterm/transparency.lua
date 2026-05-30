local wezterm = require('wezterm')

local M = {}

local default_window_opacity = 0.90
local default_text_opacity = 0.5
local default_blur = 10
local step = 0.05
local blur_step = 5
local blur_max = 100

-- Live state lives in GLOBAL so adjustments survive config reloads.
local function state()
    if not wezterm.GLOBAL.transparency then
        wezterm.GLOBAL.transparency = {
            window_opacity = default_window_opacity,
            text_opacity = default_text_opacity,
            blur = default_blur,
            enabled = true,
        }
    end
    return wezterm.GLOBAL.transparency
end

local function clamp(v)
    if v < 0.0 then return 0.0 end
    if v > 1.0 then return 1.0 end
    return v
end

local function clamp_blur(v)
    if v < 0 then return 0 end
    if v > blur_max then return blur_max end
    return v
end

local function apply(window)
    local s = state()
    if s.enabled then
        window:set_config_overrides({
            window_background_opacity = s.window_opacity,
            text_background_opacity = s.text_opacity,
            macos_window_background_blur = s.blur,
        })
    else
        window:set_config_overrides({
            window_background_opacity = 1.0,
            text_background_opacity = 1.0,
            macos_window_background_blur = s.blur,
        })
    end
end

function M.setup(config)
    config.window_background_opacity = default_window_opacity
    config.text_background_opacity = default_text_opacity
    config.macos_window_background_blur = default_blur

    wezterm.on('toggle-transparency', function(window, _)
        local s = state()
        s.enabled = not s.enabled
        apply(window)
    end)

    wezterm.on('increase-transparency', function(window, _)
        local s = state()
        s.enabled = true
        s.window_opacity = clamp(s.window_opacity - step)
        s.text_opacity = clamp(s.text_opacity - step)
        apply(window)
    end)

    wezterm.on('decrease-transparency', function(window, _)
        local s = state()
        s.enabled = true
        s.window_opacity = clamp(s.window_opacity + step)
        s.text_opacity = clamp(s.text_opacity + step)
        apply(window)
    end)

    wezterm.on('increase-blur', function(window, _)
        local s = state()
        s.blur = clamp_blur(s.blur + blur_step)
        apply(window)
    end)

    wezterm.on('decrease-blur', function(window, _)
        local s = state()
        s.blur = clamp_blur(s.blur - blur_step)
        apply(window)
    end)
end

return M
