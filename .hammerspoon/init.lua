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
