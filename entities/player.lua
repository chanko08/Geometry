local physics_component = require('components.physics')
local function player_entity(startPos, startVel, startAcc)
    self = {}
    local p = physics_component(startPos, startVel, startAcc)
    self.physics = p
    return self
end

return player_entity