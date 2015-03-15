local KTween = require('lib.tween')

local Tween = class({})

function Tween:init(key, tween_info, subject)
    -- {duration=1, type="linear", target=7, start="self"}
    self.tween = nil

    self.key      = key
    self.duration = tween_info.duration
    self.type     = tween_info.type
    self.target   = tween_info.target
    self.start    = tween_info.start

    self.subject  = subject or nil
end

function Tween:reset(s)
    self.subject = s or self.subject
    
    local t = {}
    -- print('Reset key:',self.key, 'Start:', self.start, 'Target:',self.target)
    t[self.key] = self.target

    if self.start ~= 'self' then
        self.subject[self.key] = self.start
    end

    self.tween = KTween.new(self.duration, self.subject, t, self.type)
end

function Tween:update( dt )
    if not self.tween then
        error('nil tween update attempt')    
    end

    self.tween:update(dt)
end

function Tween:finished()
    if self.tween then
        return self.tween.finished
    end

    --no tween, so finished?
    return true
end

return Tween