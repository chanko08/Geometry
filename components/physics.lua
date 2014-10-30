local Vector = require('lib.hump.vector')

local function physics_component(s, v, a)
    s = s or Vector(0, 0)
    v = v or Vector(0, 0)
    a = a or Vector(0, 0)

    self = {}
    self.s = Vector(s.x, s.y)
    self.v = Vector(v.x, v.y)
    self.a = Vector(a.x, a.y)
    return self
end

return physics_component