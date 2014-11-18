local System  = require 'systems.system'
local PhysicsComponent = require 'components.physics'


-- vector  = require 'lib.hump.vector'

local PhysicsSystem = class({})
PhysicsSystem:include(System)

function PhysicsSystem:init( manager )
    System.init(self,manager)
    manager:register('physics', self)
end

function PhysicsSystem:run( dt )
    
    
    for i,ent in ipairs(self.entities:items()) do
        
        local max_velocity = ent.max_velocity or  math.huge
        

        local s = ent.physics.s
        local v = ent.physics.v
        local a = ent.physics.a

        
        v = v + dt * a
        s = s + dt * v
        v = v:trimmed(max_velocity)

        ent.physics.s = s
        ent.physics.v = v
        print('\tVelocity'..tostring(ent.physics.v))    
    end
    
end

function PhysicsSystem:build_component( ... )
    return PhysicsComponent(...)
end

return PhysicsSystem