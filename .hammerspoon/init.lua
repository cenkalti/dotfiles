-- Reload config on keypress
hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'R', function()
    hs.reload()
end)
hs.alert.show('Config loaded')

-- For Lua type annotations (configured in ".luarc.json")
hs.loadSpoon('EmmyLua')

-- Press Cmd-Alt-R to start recording, press it again to stop.
hs.loadSpoon('VoiceToText')
spoon.VoiceToText:start()

-- Volume control with visual feedback
local function adjustVolume(delta)
    local device = hs.audiodevice.defaultOutputDevice()
    local currentVolume = device:volume()
    local newVolume = math.max(0, math.min(100, currentVolume + delta))
    device:setVolume(newVolume)
    device:setMuted(false)

    -- Show a nice volume indicator
    hs.alert.closeAll()
    hs.alert.show(string.format('🔊 %d%%', math.floor(newVolume)), 0.5)
end

-- Map F10, F11, F12 to volume controls
hs.hotkey.bind({}, 'F10', function()
    local device = hs.audiodevice.defaultOutputDevice()
    device:setMuted(not device:muted())
end)
hs.hotkey.bind({}, 'F11', function()
    adjustVolume(-5)
end)
hs.hotkey.bind({}, 'F12', function()
    adjustVolume(5)
end)
