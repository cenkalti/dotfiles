local wezterm = require('wezterm')

local M = {}

function M.setup(_)
    wezterm.on('toggle-quake', function(window, pane)
        wezterm.GLOBAL.quake_panes = wezterm.GLOBAL.quake_panes or {}
        local quake_panes = wezterm.GLOBAL.quake_panes
        local tab = window:active_tab()
        local tab_key = tostring(tab:tab_id())
        local existing_id = quake_panes[tab_key]

        if existing_id then
            for _, info in ipairs(tab:panes_with_info()) do
                if info.pane:pane_id() == existing_id then
                    info.pane:activate()
                    window:perform_action(
                        wezterm.action.CloseCurrentPane({ confirm = false }),
                        info.pane
                    )
                    quake_panes[tab_key] = nil
                    return
                end
            end
            quake_panes[tab_key] = nil
        end

        local new_pane = pane:split({
            direction = 'Bottom',
            size = 0.2,
        })
        quake_panes[tab_key] = new_pane:pane_id()
    end)
end

return M
