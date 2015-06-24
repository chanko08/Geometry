local System = require 'systems.system'

local Physics = class({})
Physics:include(System)


function Physics:init( ... )
    System.init(self, ...)
end


local function integrate(dt, ent)
    ent.physics.v = ent.physics.v + dt*ent.physics.a
    ent.physics.s = ent.physics.s + dt*ent.physics.v
end

function Physics:run( ecs, dt )
    ecs:run_with( curry(integrate, dt), {'physics'} )
end

return Physics