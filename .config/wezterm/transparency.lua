local wezterm = require('wezterm')

local M = {}

local default_window_opacity = 0.90
local default_text_opacity = 0.5
local default_blur = 10
local step = 0.05
local blur_step = 5
local blur_max = 100

local window_opacity = default_window_opacity
local text_opacity = default_text_opacity
local blur = default_blur
local transparency_enabled = true

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
    if transparency_enabled then
        window:set_config_overrides({
            window_background_opacity = window_opacity,
            text_background_opacity = text_opacity,
            macos_window_background_blur = blur,
        })
    else
        window:set_config_overrides({
            window_background_opacity = 1.0,
            text_background_opacity = 1.0,
            macos_window_background_blur = blur,
        })
    end
end

function M.setup(config)
    config.window_background_opacity = default_window_opacity
    config.text_background_opacity = default_text_opacity
    config.macos_window_background_blur = default_blur

    wezterm.on('toggle-transparency', function(window, _)
        transparency_enabled = not transparency_enabled
        apply(window)
    end)

    wezterm.on('increase-transparency', function(window, _)
        transparency_enabled = true
        window_opacity = clamp(window_opacity - step)
        text_opacity = clamp(text_opacity - step)
        apply(window)
    end)

    wezterm.on('decrease-transparency', function(window, _)
        transparency_enabled = true
        window_opacity = clamp(window_opacity + step)
        text_opacity = clamp(text_opacity + step)
        apply(window)
    end)

    wezterm.on('increase-blur', function(window, _)
        blur = clamp_blur(blur + blur_step)
        apply(window)
    end)

    wezterm.on('decrease-blur', function(window, _)
        blur = clamp_blur(blur - blur_step)
        apply(window)
    end)
end

return M
