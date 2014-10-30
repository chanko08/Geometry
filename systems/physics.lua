class   = require 'lib.hump.class'
System  = require 'systems.system'

inspect = require 'lib.inspect'
-- vector  = require 'lib.hump.vector'

local PhysicsSystem = class({})
PhysicsSystem:include(System)

function PhysicsSystem:init( manager )
    System.init(self,manager)
    manager:register('physics', self)
end

function PhysicsSystem:run( dt )
    for ent in self.entities:iter() do
        
        local max_velocity = ent.max_velocity or  math.huge
        

        local s = ent.physics.s
        local v = ent.physics.v
        local a = ent.physics.a

        s = s + dt * v
        v = v + dt * a
        v = v:trimmed(max_velocity)


        ent.physics.s = s
        ent.physics.v = v
        
    end
end

return PhysicsSystem