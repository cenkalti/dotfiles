local obj = {}
obj.__index = obj

obj.name = 'VoiceToText'
obj.version = '1.0'
obj.author = 'Cenk Alti'
obj.homepage = 'https://github.com/cenkalti/dotfiles'
obj.license = 'MIT'

-- Configuration constants
obj.FFMPEG_PATH = '/opt/homebrew/bin/ffmpeg'
obj.WHISPER_PATH = '/Users/cenk/.local/bin/whisper'
obj.WHISPER_MODEL = 'base'
obj.PATH_ENV = '/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin'

obj.hotkey = nil
obj.recordingTask = nil
obj.transcriptionTask = nil
obj.tempDir = nil
obj.tempAudioFile = nil
obj.tempJsonFile = nil
obj.recordingAlert = nil
obj.transcriptionAlert = nil

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

function obj:closeAlert(alert)
    if alert then
        hs.alert.closeSpecific(alert)
    end
    return nil
end

function obj:terminateTask(task, wait)
    if task then
        task:terminate()
        if wait then
            task:waitUntilExit()
        end
    end
    return nil
end

function obj:logError(prefix, exitCode, stdOut, stdErr)
    local errorMsg = stdErr or 'Unknown error'
    print(prefix .. ' Error (exit code: ' .. exitCode .. '): ' .. errorMsg)
    if stdOut and stdOut:len() > 0 then
        print(prefix .. ' Output: ' .. stdOut)
    end
end

function obj:stop()
    if self.hotkey then
        self.hotkey:delete()
        self.hotkey = nil
    end
    self.recordingTask = self:terminateTask(self.recordingTask)
    self.transcriptionTask = self:terminateTask(self.transcriptionTask)
    self.recordingAlert = self:closeAlert(self.recordingAlert)
    self.transcriptionAlert = self:closeAlert(self.transcriptionAlert)
    if self.tempDir and hs.fs.attributes(self.tempDir) then
        os.execute('rm -r ' .. self.tempDir)
    end
    return self
end

function obj:toggleRecording()
    if self.recordingTask then
        self:stopRecording()
        self:startTranscribe()
    elseif self.transcriptionTask then
        self:stopTranscribe()
        self:startRecording()
    else
        self:startRecording()
    end
end

function obj:startRecording()
    self.recordingTask = hs.task.new(
        self.FFMPEG_PATH,
        function(exitCode, stdOut, stdErr)
            self:recordingTaskHandler(exitCode, stdOut, stdErr)
        end,
        { '-f', 'avfoundation', '-i', ':default', '-ar', '16000', '-ac', '1', '-b:a', '192k', '-y', self.tempAudioFile }
    )

    self.recordingTask:start()
    self.recordingAlert = hs.alert.show('🎤 Recording...', 'indefinite')
end

function obj:stopRecording()
    self.recordingAlert = self:closeAlert(self.recordingAlert)
    self.recordingTask = self:terminateTask(self.recordingTask, true)
end

function obj:startTranscribe()
    if not self.tempAudioFile or not hs.fs.attributes(self.tempAudioFile) then
        hs.alert.show('No audio file found')
        return
    end

    self.transcriptionTask = hs.task.new(self.WHISPER_PATH, function(exitCode, stdOut, stdErr)
        self:transcriptionTaskHandler(exitCode, stdOut, stdErr)
    end, {
        self.tempAudioFile,
        '--model',
        self.WHISPER_MODEL,
        '--output_format',
        'json',
        '--output_dir',
        self.tempDir,
    })

    -- Set environment variables to help Whisper find ffmpeg
    self.transcriptionTask:setEnvironment({
        PATH = self.PATH_ENV,
    })

    self.transcriptionTask:start()
    self.transcriptionAlert = hs.alert.show('🤖 Transcribing...', 'indefinite')
end

function obj:stopTranscribe()
    self.transcriptionAlert = self:closeAlert(self.transcriptionAlert)
    self.transcriptionTask = self:terminateTask(self.transcriptionTask)
end

function obj:recordingTaskHandler(exitCode, stdOut, stdErr)
    -- Exit code 255 is expected when ffmpeg is terminated normally
    if exitCode == 0 or exitCode == 255 then
        return
    end

    self:logError('VoiceToText Recording', exitCode, stdOut, stdErr)
    hs.alert.show('Recording failed')
end

function obj:transcriptionTaskHandler(exitCode, stdOut, stdErr)
    self.transcriptionAlert = self:closeAlert(self.transcriptionAlert)
    self.transcriptionTask = nil

    if exitCode == 15 then -- Exit code 15 is expected when whisper is terminated normally
        print('VoiceToText Transcription Stopped')
        return
    end

    if exitCode ~= 0 then
        self:logError('VoiceToText Transcription', exitCode, stdOut, stdErr)
        hs.alert.show('Transcription failed')
        return
    end

    -- Read the JSON file that Whisper created
    if not hs.fs.attributes(self.tempJsonFile) then
        hs.alert.show('No transcription file found')
        return
    end

    local file = io.open(self.tempJsonFile, 'r')
    if not file then
        hs.alert.show('Failed to read transcription file')
        return
    end

    local content = file:read('*all')
    file:close()

    local response = hs.json.decode(content)
    if not response or not response.text then
        hs.alert.show('Failed to parse transcription')
        return
    end

    if response.text:len() == 0 then
        hs.alert.show('No speech detected')
        return
    end

    hs.pasteboard.setContents(response.text)
    hs.eventtap.keyStroke({ 'cmd' }, 'v')
end

return obj