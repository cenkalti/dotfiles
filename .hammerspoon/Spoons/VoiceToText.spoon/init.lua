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
obj.tempDir = nil
obj.tempAudioFile = nil
obj.tempJsonFile = nil
obj.recordingAlert = nil

function obj:init()
    self.tempDir = os.tmpname()
    os.remove(self.tempDir)
    hs.fs.mkdir(self.tempDir)
    self.tempAudioFile = self.tempDir .. '/audio.mp3'
    self.tempJsonFile = self.tempDir .. '/audio.json'
    return self
end

function obj:start()
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
    if self.tempDir and hs.fs.attributes(self.tempDir) then
        -- Clean up temp files
        if self.tempAudioFile and hs.fs.attributes(self.tempAudioFile) then
            os.remove(self.tempAudioFile)
        end
        if self.tempJsonFile and hs.fs.attributes(self.tempJsonFile) then
            os.remove(self.tempJsonFile)
        end
        -- Remove empty directory
        os.remove(self.tempDir)
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

    local whisperTask = hs.task.new('/Users/cenk/.local/bin/whisper', function(exitCode, stdOut, stdErr)
        if exitCode == 0 then
            -- Read the JSON file that Whisper created
            if hs.fs.attributes(self.tempJsonFile) then
                local file = io.open(self.tempJsonFile, 'r')
                if file then
                    local content = file:read('*all')
                    file:close()

                    local response = hs.json.decode(content)
                    if response and response.text then
                        if response.text:len() > 0 then
                            self:pasteText(response.text)
                        else
                            hs.alert.show('No speech detected', 3)
                        end
                    else
                        hs.alert.show('Failed to parse transcription', 3)
                    end
                else
                    hs.alert.show('Failed to read transcription file', 3)
                end
            else
                hs.alert.show('No transcription file found', 3)
            end
        else
            local errorMsg = stdErr or 'Unknown error'
            print('VoiceToText Transcription Error (exit code: ' .. exitCode .. '): ' .. errorMsg)
            if stdOut and stdOut:len() > 0 then
                print('VoiceToText Transcription Output: ' .. stdOut)
            end
            hs.alert.show('Transcription failed', 3)
        end
    end, {
        self.tempAudioFile,
        '--model',
        'base',
        '--output_format',
        'json',
        '--output_dir',
        self.tempDir,
    })

    -- Set environment variables to help Whisper find ffmpeg
    whisperTask:setEnvironment({
        PATH = '/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin',
    })

    if whisperTask then
        whisperTask:start()
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