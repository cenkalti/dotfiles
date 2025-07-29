local wezterm = require('wezterm')

local M = {}

local default_windows_background_opacity = 0.90
local default_text_background_opacity = 0.5
local transparency_enabled = true

function M.setup(config)
    config.window_background_opacity = default_windows_background_opacity
    config.text_background_opacity = default_text_background_opacity

    wezterm.on('toggle-transparency', function(window, _)
        if transparency_enabled then
            transparency_enabled = false
            window:set_config_overrides({
                window_background_opacity = 1.0,
                text_background_opacity = 1.0,
            })
        else
            transparency_enabled = true
            window:set_config_overrides({
                window_background_opacity = default_windows_background_opacity,
                text_background_opacity = default_text_background_opacity,
            })
        end
    end)
end

return M