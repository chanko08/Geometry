local System             = require 'systems.system'
local CollisionComponent = require 'components.collision'
local HC                 = require 'lib.HardonCollider'
local Vector             = require 'lib.hump.vector'

-- vector  = require 'lib.hump.vector'

local CollisionSystem = class({})
CollisionSystem:include(System)

function CollisionSystem:init( state )
    System.init(self,state)

    local on_collision      = _.curry(CollisionSystem.on_collision, self)
    local on_stop_collision = _.curry(CollisionSystem.on_stop_collision, self)
    self.collider           = HC(100, on_collision, on_stop_collision)

    self.relay:register('remove_collision_shape',_.curry(self.remove_entity_from_world,self))
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
            if ent.name == 'player' and math.abs(ent.physics.v.y) > 100 then
                self.relay:emit('land',ent)
            end
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
    local shape_name = shape.component.name or shape.component.entity.name
    local other_shape_name = other_shape.component.name or other_shape.component.entity.name

    -- TODO remove this, no longer needed because this collision is handled with groups now

    -- print('\tResolve vector: ('..mx..','..my..')')
    if shape.is_sensor and other_shape.is_sensor then
        return
    end
    

    if _.any(other_shape.component.groups, function(group) return group == 'terrain' end) then
        shape.component.stop_vertical_movement = true
        -- print('I AM STOPPING!')
    else
        shape.component.stop_vertical_movement = shape.component.stop_vertical_movement or false
    end

    if shape.is_sensor then
        if shape.component.signal.when_on then
            self.relay:emit(shape.component.signal.when_on, shape.component, other_shape.component)
        end
        shape.component.resolve_vector = shape.component.resolve_vector + Vector(mx,my)
        shape.component.has_collided = true
        shape.component.colliding_shape = other_shape

    elseif other_shape.is_sensor then
        if other_shape.component.signal.when_on then
            self.relay:emit(other_shape.component.signal.when_on, other_shape.component, shape.component)
        end

        other_shape.component.resolve_vector = other_shape.component.resolve_vector - Vector(mx,my)
        other_shape.component.has_collided = true
        other_shape.component.colliding_shape = shape

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
    local shape_name = shape.component.name or shape.component.entity.name
    local other_shape_name = other_shape.component.name or other_shape.component.entity.name

    if shape.is_sensor and other_shape.is_sensor then
        return
    end
    
    if shape.is_sensor and shape.component.signal.when_off then
            self.relay:emit(shape.component.signal.when_off, shape.component, other_shape.component)
    end

    if other_shape.is_sensor and other_shape.component.signal.when_off then
            self.relay:emit(other_shape.component.signal.when_off, other_shape.component, shape.component)
    end

    shape.component.has_collided = false
    shape.colliding_shape = nil
    other_shape.colliding_shape = nil
    shape.component.stop_vertical_movement = false
    if not other_shape.component.is_passive then
        other_shape.component.has_collided = false
    end

end

function CollisionSystem:remove_entity_from_world(collision)
    local remove = _.curry(self.collider.remove,self.collider)
    
    remove(collision.shape)
    for i, s in pairs(collision.sensors) do
        remove(s.shape)
    end
end

function CollisionSystem:build_component( obj, comp_data )

    return CollisionComponent(self.collider, obj, comp_data)
end

return CollisionSystem