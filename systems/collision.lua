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
    --manager:register('sensors', self)

    local on_collision = _.curry(CollisionSystem.on_collision, self)
    local on_stop_collision = _.curry(CollisionSystem.on_stop_collision, self)
    self.collider = HC(100, on_collision, on_stop_collision)
end

function CollisionSystem:run( dt )
    -- Tell the collider to think about shit
    for i,ent in ipairs(self:get_entities('collision')) do
        local v = ent.physics.s + ent.collision.offset
        ent.collision.shape:moveTo(v:unpack())

        local cx, cy = ent.collision.shape:center()
        for j, sensor in pairs(ent.collision.sensors) do
            sensor.shape:moveTo(cx + sensor.rel_x, cy + sensor.rel_y)
        end
    end

    self.collider:update(dt)

    -- Resolve da collisions, bitch
    for i,ent in ipairs(self:get_entities('collision')) do

        ent.physics.s = ent.physics.s + ent.collision.resolve_vector
        -- local s = ent.physics.s + ent.collision.offset

        if ent.collision.stop_vertical_movement then
            ent.physics.v.y = 0
        end

        -- ent.collision.shape:moveTo(s:unpack())
        ent.collision.shape:setRotation(ent.physics.rot)
        ent.collision.shape:move(ent.collision.resolve_vector:unpack())
        for j, sensor in pairs(ent.collision.sensors) do
            sensor.shape:move(ent.collision.resolve_vector:unpack())
        end
        ent.collision.resolve_vector = Vector(0,0)
    end
end

function CollisionSystem:on_collision(dt, shape, other_shape, mx, my)
    -- print('COLLIDING: '.. inspect(shape.component.groups)..' with '.. inspect(other_shape.component.groups))

    if shape.is_sensor and other_shape.is_sensor then
        return
    end

    -- print('\tResolve vector: ('..mx..','..my..')')

    if _.any(other_shape.component.groups, function(group) return group == 'Terrain' end) then
        shape.component.stop_vertical_movement = true
        -- print('I AM STOPPING!')
    else
        shape.component.stop_vertical_movement = shape.component.stop_vertical_movement or false
    end

    if shape.is_sensor then
        shape.component.resolve_vector = shape.component.resolve_vector + Vector(mx,my)
        shape.component.has_collided = true

    elseif other_shape.is_sensor then
        other_shape.component.resolve_vector = other_shape.component.resolve_vector - Vector(mx,my)
        other_shape.component.has_collided = true

    elseif not other_shape.component.is_passive then
        shape.component.has_collided = true
        other_shape.component.has_collided = true

        shape.component.resolve_vector       = shape.component.resolve_vector + 0.5*Vector(mx,my)
        other_shape.component.resolve_vector = other_shape.component.resolve_vector - 0.5*Vector(mx,my)

    else
        shape.component.has_collided = true
        shape.component.resolve_vector = shape.component.resolve_vector + Vector(mx,my)
    end
end

function CollisionSystem:on_stop_collision(dt, shape, other_shape)
    -- print('\tSTOP COLLIDING: '..shape.component.shape_name..' with '..other_shape.component.shape_name)
    if shape.is_sensor and other_shape.is_sensor then
        return
    end

    shape.component.has_collided = false
    shape.component.stop_vertical_movement = false
    if not other_shape.component.is_passive then
        other_shape.component.has_collided = false
    end

end

function CollisionSystem:build_component( layer, obj, comp_data )

    return CollisionComponent(self.collider, layer, obj, comp_data)
end

return CollisionSystem