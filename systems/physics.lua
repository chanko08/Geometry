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
    self.collisions = {}
end


local function integrate(dt, ent)
    ent.physics.v = ent.physics.v + dt*ent.physics.a
    -- ent.physics.s = ent.physics.s + dt*ent.physics.v

    ent.physics.shape:move((ent.physics.v*dt):unpack())
end

local function clean_up_collider( collider, ent )
    collider:remove(ent.physics.shape)
end

function Physics:on_collision(dt, a, b, dx, dy )
    push( self.collisions, {a, b, dx, dy} )

    print(inspect(a, {depth=2}))
end

function Physics:on_stop_collision(dt, a, b, dx, dy )
    print('STOPPED POOPIONG')
end

function Physics:run( ecs, dt )
    for i,ent in ipairs(ecs:recently_added()) do
        if ent.physics then
            self.collider:addShape(ent.physics.shape)
        end
    end

    for i,ent in ipairs(ecs:staged_for_deletion()) do
        if ent.physics then
            self.collider:remove(ent.physics.shape)
        end
    end

    ecs:run_with( curry(integrate, dt), {'physics'} )
    self.collider:update(dt)

    for i,collision_pair in ipairs(self.collisions) do
        local a,b,dx,dy = unpack(collision_pair)

        a:move( dx/2,  dy/2)
        b:move(-dx/2, -dy/2)

    end

    self.collisions = {}
end

return Physics