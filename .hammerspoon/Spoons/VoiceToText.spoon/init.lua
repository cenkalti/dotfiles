local obj = {}
obj.__index = obj

obj.name = 'VoiceToText'
obj.version = '1.0'
obj.author = 'Cenk Alti'
obj.homepage = 'https://github.com/cenkalti/dotfiles'
obj.license = 'MIT'

obj.hotkey = nil
obj.isRecording = false
obj.recordingTask = nil
obj.tempAudioFile = nil
obj.openaiApiKey = nil
obj.recordingAlert = nil

function obj:init()
    self.tempAudioFile = os.tmpname() .. '.mp3'
    self.openaiApiKey = hs.settings.get('openai_api_key')
    return self
end

function obj:start()
    if not self.openaiApiKey then
        hs.alert.show("OpenAI API key not found. Set with: hs.settings.set('openai_api_key', 'your-key')", 5)
        return self
    end

    self.hotkey = hs.hotkey.bind({}, 'f5', function()
        self:toggleRecording()
    end)
    return self
end

function obj:stop()
    if self.hotkey then
        self.hotkey:delete()
        self.hotkey = nil
    end
    if self.recordingTask then
        self.recordingTask:terminate()
        self.recordingTask = nil
    end
    if self.tempAudioFile and hs.fs.attributes(self.tempAudioFile) then
        os.remove(self.tempAudioFile)
    end
    return self
end

function obj:toggleRecording()
    if self.isRecording then
        self:stopRecording()
    else
        self:startRecording()
    end
end

function obj:startRecording()
    if self.isRecording then
        return
    end

    self.isRecording = true
    self.recordingAlert = hs.alert.show('🎤 Recording...', 'indefinite')

    self.recordingTask = hs.task.new(
        '/opt/homebrew/bin/ffmpeg',
        function(exitCode, stdOut, stdErr)
            -- Exit code 255 is expected when ffmpeg is terminated normally
            if exitCode ~= 0 and exitCode ~= 255 then
                local errorMsg = stdErr or 'Unknown error'
                print('VoiceToText Recording Error (exit code: ' .. exitCode .. '): ' .. errorMsg)
                if stdOut and stdOut:len() > 0 then
                    print('VoiceToText Recording Output: ' .. stdOut)
                end
                hs.alert.show('Recording failed', 3)
                self.isRecording = false
            end
        end,
        { '-f', 'avfoundation', '-i', ':default', '-ar', '16000', '-ac', '1', '-b:a', '192k', '-y', self.tempAudioFile }
    )

    if self.recordingTask then
        self.recordingTask:start()
    else
        hs.alert.show('Failed to start recording', 3)
        self.isRecording = false
    end
end

function obj:stopRecording()
    if not self.isRecording then
        return
    end

    self.isRecording = false

    if self.recordingAlert then
        hs.alert.closeAll()
        self.recordingAlert = nil
    end

    if self.recordingTask then
        self.recordingTask:terminate()
        self.recordingTask:waitUntilExit()
        self.recordingTask = nil
    end

    self:transcribeAudio()
end

function obj:transcribeAudio()
    if not self.tempAudioFile or not hs.fs.attributes(self.tempAudioFile) then
        hs.alert.show('No audio file found', 3)
        return
    end

    local curlTask = hs.task.new('/usr/bin/curl', function(exitCode, stdOut, stdErr)
        if exitCode == 0 and stdOut and stdOut:len() > 0 then
            local success, response = pcall(hs.json.decode, stdOut)
            if success and response and response.text then
                local transcription = response.text:gsub('^%s*(.-)%s*$', '%1')
                if transcription and transcription:len() > 0 then
                    self:pasteText(transcription)
                else
                    hs.alert.show('No speech detected', 3)
                end
            else
                print('VoiceToText JSON Parse Error: ' .. (stdOut or 'No output'))
                hs.alert.show('Failed to parse response', 3)
            end
        else
            local errorMsg = stdErr or 'Unknown error'
            print('VoiceToText Transcription Error (exit code: ' .. exitCode .. '): ' .. errorMsg)
            if stdOut and stdOut:len() > 0 then
                print('VoiceToText Transcription Output: ' .. stdOut)
            end
            hs.alert.show('Transcription failed', 3)
        end

        if hs.fs.attributes(self.tempAudioFile) then
            os.remove(self.tempAudioFile)
        end
    end, {
        '-X',
        'POST',
        '-H',
        'Authorization: Bearer ' .. self.openaiApiKey,
        '-H',
        'Content-Type: multipart/form-data',
        '-F',
        'file=@' .. self.tempAudioFile,
        '-F',
        'model=whisper-1',
        'https://api.openai.com/v1/audio/transcriptions',
    })

    if curlTask then
        curlTask:start()
    else
        hs.alert.show('Failed to start transcription', 3)
    end
end

function obj:pasteText(text)
    local currentApp = hs.application.frontmostApplication()
    if currentApp then
        hs.pasteboard.setContents(text)
        hs.eventtap.keyStroke({ 'cmd' }, 'v')
    else
        hs.alert.show('No active window found', 3)
    end
end

return obj