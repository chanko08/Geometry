local System = require 'systems.system'
local HC     = require 'lib.HardonCollider'
local Physics = class({})
Physics:include(System)


--[[
    physics component has to have:
        s : position
        v : velocity
        a : acceleration
        collision : table where keys are entity ids that store the offset to resolve the collision


        the collider shape has to have two additional properties:
        component : the reference to the component that 'owns' the collider shape (for the callbacks)
        ent_id    : the entity reference number to refer to the entity that 'owns' the component
]]

function Physics:init( )
    System.init(self)
    self.collider = HC(150, curry(self.on_collision, self), curry(self.on_stop_collision, self))
end


local function integrate(dt, ent)
    ent.physics.v = ent.physics.v + dt*ent.physics.a
    ent.physics.s = ent.physics.s + dt*ent.physics.v
end

local function clean_up_collider( collider, ent )
    collider:remove(ent.physics.shape)
end

local function resolve_collisions(ent)
    -- local actual_resolve_vector = Vector(0,0)
    -- for collision_entity_id,resolve_vector in pairs(ent.physics.shape.collision) do
    --     actual_resolve_vector - resolve_vector
    -- end
end

function Physics:on_collision(dt, a, b, dx, dy )
    local delta = vector(dx, dy)

    a.collision[b.ent_id] =  delta
    b.collision[a.ent_id] = -delta

end

function Physics:on_stop_collision(dt, a, b, dx, dy )
    a.collision[b.ent_id] = nil
    b.collision[a.ent_id] = nil

end

function Physics:run( ecs, dt )
    ecs:run_with( curry(integrate, dt), {'physics'} )
    -- for i=1,10 do
    --     self.collider:update(dt/10)
    -- end
    
    -- for i,collision in ipairs(self.collider:get_collisions) do
    --     resolve_this_particular
    -- end
    -- map(ecs:removed_entities, curry(clean_up_collider, self.collider))

end

return Physics