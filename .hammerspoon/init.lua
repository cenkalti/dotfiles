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

hs.loadSpoon('NoLED')
spoon.NoLED:startSchedule()

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

-- Map F4 to run ask command
hs.hotkey.bind({}, 'F4', function()
    local output, status, exitType, exitCode = hs.execute('cd ~/projects/gi && /opt/homebrew/bin/go run ./cmd/ask 2>&1')
    local trimmedOutput = output and output:gsub('%s+$', '') or 'No output'
    hs.alert.show(trimmedOutput, 3)
end)

-- Map F7 to previous track
hs.hotkey.bind({}, 'F7', function()
    hs.eventtap.event.newSystemKeyEvent('PREVIOUS', true):post()
    hs.eventtap.event.newSystemKeyEvent('PREVIOUS', false):post()
end)

-- Map F8 to play/pause media
hs.hotkey.bind({}, 'F8', function()
    hs.eventtap.event.newSystemKeyEvent('PLAY', true):post()
    hs.eventtap.event.newSystemKeyEvent('PLAY', false):post()
end)

-- Map F9 to next track
hs.hotkey.bind({}, 'F9', function()
    hs.eventtap.event.newSystemKeyEvent('NEXT', true):post()
    hs.eventtap.event.newSystemKeyEvent('NEXT', false):post()
end)

-- Map F10, F11, F12 to volume controls
hs.hotkey.bind({}, 'F10', function()
    local device = hs.audiodevice.defaultOutputDevice()
    local wasMuted = device:muted()
    device:setMuted(not wasMuted)

    hs.alert.closeAll()
    hs.alert.show(wasMuted and 'Unmuted' or 'Muted', 0.5)
end)
hs.hotkey.bind({}, 'F11', function()
    adjustVolume(-5)
end)
hs.hotkey.bind({}, 'F12', function()
    adjustVolume(5)
end)
