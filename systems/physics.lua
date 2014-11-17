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
    
    -- dt = dt / 4
    for i,ent in ipairs(self.entities:items()) do
        
        local max_velocity = ent.max_velocity or  math.huge
        

        local s = ent.physics.s
        local v = ent.physics.v
        local a = ent.physics.a

        
        v = v + dt * a
        v = v:trimmed(max_velocity)
        s = s + dt * v

        ent.physics.s = s
        ent.physics.v = v
        -- print('\tVelocity'..tostring(ent.physics.v))
        -- if ent.collision then
        --     ent.collision.shape:moveTo(s:unpack())
        -- end            
    end
    
end

function PhysicsSystem:build_component( ... )
    return PhysicsComponent(...)
end

return PhysicsSystem