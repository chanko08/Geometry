local KTween = require('lib.tween')

local Tween = class({})

function Tween:init(key, tween_info)
    -- {duration=1, type="linear", target=7, start="self"}
    self.tween = nil

    self.key = key
    self.duration = tween_info.duration
    self.type     = tween_info.type
    self.target   = tween_info.target
    self.start    = tween_info.start
    self.loop     = tween_info.loop or false

    self.is_looping = true
end

function Tween:reset(subject)
    local t = {}
    t[self.key] = self.target

    if self.start ~= 'self' then
        subject[self.key] = self.start
    end

    self.is_looping = self.loop
    self.tween = KTween.new(self.duration, subject, t, self.type)
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