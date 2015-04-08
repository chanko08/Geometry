local Vector = require('lib.hump.vector')

local PhysicsComponent = class({})
function PhysicsComponent:init( obj, comp_data )
    -- TODO: Maybe give error if no position?
    local s = Vector(obj.x,obj.y)
    if obj.x == nil or obj.y == nil then
        s = Vector(0,0)
    end
    local v = comp_data.v or Vector(0, 0)
    local a = comp_data.a or Vector(0, 0)

    local rot = comp_data.rot or 0

    if comp_data.gravity then
        a.y = comp_data.gravity
    end

    
    self.s = Vector(s.x, s.y)
    self.v = Vector(v.x, v.y)
    self.a = Vector(a.x, a.y)
    self.gravity = comp_data.gravity or 0
    self.rot = rot
end

return PhysicsComponent