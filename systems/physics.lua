local System  = require 'systems.system'
local PhysicsComponent = require 'components.physics'


-- vector  = require 'lib.hump.vector'

local PhysicsSystem = class({})
PhysicsSystem:include(System)

function PhysicsSystem:init( state )
    System.init(self,state)
end

function PhysicsSystem:run( dt )
    
    -- dt = dt / 4
    for i,ent in ipairs(self:get_entities('physics')) do
        
        local max_velocity = ent.max_velocity or  math.huge
        

        local s = ent.physics.s
        local v = ent.physics.v
        local a = ent.physics.a

        
        s = s + dt * v
        v = v + dt * a
        v = v:trimmed(max_velocity)

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