local State = class({})

-- e.g. on_enter is called when the state machine enters this state
function State:init(name, on_enter, on_update, on_leave)
    self.name     = name

    self.on_enter  = on_enter  or _.identity
    self.on_update = on_update or _.identity
    self.on_leave  = on_leave  or _.identity
end

function State:update(dt)
    self.on_update(dt)
end

function State:enter( ... )
    self.on_enter( ... )
end

function State:leave( ... )
    self.on_leave( ... )
end

return State