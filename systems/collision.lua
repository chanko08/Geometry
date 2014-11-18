local System             = require 'systems.system'
local CollisionComponent = require 'components.collision'
local HC                 = require 'lib.HardonCollider'
local Vector             = require 'lib.hump.vector'

-- vector  = require 'lib.hump.vector'

local CollisionSystem = class({})
CollisionSystem:include(System)

function CollisionSystem:init( manager )
    System.init(self,manager)
    manager:register('collision', self)
    manager:register('sensors', self)

    local on_collision = _.curry(CollisionSystem.on_collision, self)
    local on_stop_collision = _.curry(CollisionSystem.on_collision, self)
    self.collider = HC(100, on_collision, on_stop_collision)
end

function CollisionSystem:run( dt )
    -- Tell the collider to think about shit
    for i,ent in ipairs(self.entities:items()) do
        local v = ent.physics.s + ent.collision.offset
        ent.collision.shape:moveTo(v:unpack())

        local cx, cy = ent.collision.shape:center()
        for j, sensor in ipairs(ent.collision.sensors) do
            sensor.shape:moveTo(cx + sensor.rel_x, cy + sensor.rel_y)
        end
    end

    self.collider:update(dt)

    -- Resolve da collisions, bitch
    for i,ent in ipairs(self.entities:items()) do

        ent.physics.s = ent.physics.s + ent.collision.resolve_vector
        -- local s = ent.physics.s + ent.collision.offset

        if ent.collision.has_collided then
            ent.physics.v.y = 0
        end

        -- ent.collision.shape:moveTo(s:unpack())
        ent.collision.shape:move(ent.collision.resolve_vector:unpack())
        ent.collision.resolve_vector = Vector(0,0)
    end
end

function CollisionSystem:on_collision(dt, shape, other_shape, mx, my)
    print('COLLIDING: '..shape.component.shape_name..' with '..other_shape.component.shape_name)
    print('\tResolve vector: ('..mx..','..my..')')
    if not other_shape.is_sensor then
        shape.component.has_collided = true
        shape.component.resolve_vector = shape.component.resolve_vector + Vector(mx,my)
    end
end

function CollisionSystem:on_stop_collision(dt, shape, other_shape)
    print('\tSTOP COLLIDING: '..shape.component.shape_name..' with '..other_shape.component.shape_name)
    shape.component.has_collided = false
    
end

function CollisionSystem:build_component( layer, obj, comp_data )

    return CollisionComponent(self.collider, layer, obj, comp_data)
end

return CollisionSystem