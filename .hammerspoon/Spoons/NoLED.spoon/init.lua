-- NoLED: Toggle MagSafe LED on/off
-- Requires sudoers configuration at /etc/sudoers.d/noled
-- Run this command to create the required file:
-- echo "ALL ALL = (ALL) NOPASSWD: /usr/local/bin/smc -k ACLC -w 01, /usr/local/bin/smc -k ACLC -w 00" | sudo tee /etc/sudoers.d/noled > /dev/null && sudo chmod 0440 /etc/sudoers.d/noled

local obj = {}
obj.__index = obj

obj.name = 'NoLED'
obj.version = '1.0'
obj.author = 'Cenk Alti'
obj.homepage = 'https://github.com/cenkalti/dotfiles'
obj.license = 'MIT'

obj.CMD_DISABLE_LED = 'sudo -n /usr/local/bin/smc -k ACLC -w 01 2>&1'
obj.CMD_ENABLE_LED = 'sudo -n /usr/local/bin/smc -k ACLC -w 00 2>&1'

obj.timer = nil
obj.isActive = false
obj.scheduleTimer = nil

function obj:init()
    return self
end

function obj:isNightTime()
    local hour = tonumber(os.date('%H'))
    return hour >= 22 or hour < 8
end

function obj:applyScheduledState()
    if self:isNightTime() then
        if not self.isActive then
            self:startSmcLoop()
        end
    else
        if self.isActive then
            self:stopSmcLoop()
        end
    end
end

function obj:startSchedule()
    self:applyScheduledState()
    self.scheduleTimer = hs.timer.doEvery(60, function()
        self:applyScheduledState()
    end)
    return self
end

function obj:stopSchedule()
    if self.scheduleTimer then
        self.scheduleTimer:stop()
        self.scheduleTimer = nil
    end
    return self
end

function obj:toggleSmcLoop()
    if self.isActive then
        self:stopSmcLoop()
    else
        self:startSmcLoop()
    end
end

function obj:startSmcLoop()
    local output, status, type, rc = hs.execute(self.CMD_DISABLE_LED)
    if rc ~= 0 then
        print('NoLED Error: smc command failed')
        print('Exit code:', rc)
        print('Output:', output)
        hs.alert.show('NoLED Error: Check console for details', 3)
        return
    end

    self.isActive = true
    self.timer = hs.timer.doEvery(0.1, function()
        hs.execute(self.CMD_DISABLE_LED)
    end)
    hs.alert.show('Magsafe LED: Disabled', 1)
end

function obj:stopSmcLoop()
    self.isActive = false
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end
    local output, status, type, rc = hs.execute(self.CMD_ENABLE_LED)
    if rc ~= 0 then
        print('NoLED Error: smc command failed')
        print('Exit code:', rc)
        print('Output:', output)
        hs.alert.show('NoLED Error: Check console for details', 3)
        return
    end
    hs.alert.show('Magsafe LED: Enabled', 1)
end

function obj:stop()
    self:stopSmcLoop()
    return self
end

return obj
