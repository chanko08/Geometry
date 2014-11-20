local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')


local function build_shape( self, collider, layer, obj, comp_data )
    self.shape_name = comp_data.shape or obj.shape 
    
    -- We might want to change this later... assumption is
    -- that there will be more walls and static objects than
    -- dynamic ones...
    if comp_data.is_passive ~= nil then
        self.is_passive = comp_data.is_passive
    else
        self.is_passive = true
    end


    self.groups          = comp_data.groups or {layer.name} or {obj.name}
    
    self.has_collided   = false
    self.resolve_vector = Vector(0,0)


    if self.shape_name == 'rectangle' then
        self.shape = collider:addRectangle(obj.x, obj.y, obj.width, obj.height)
        self.shape.component = self

        self.offset = Vector(obj.width / 2, obj.height / 2)

    elseif self.shape_name == 'circle' then

        self.offset = Vector(obj.width / 2, obj.width / 2)
        self.shape = collider:addCircle(obj.x + self.offset.x, obj.y + self.offset.y, obj.width / 2)
        self.shape.component = self


    else
        error('Unknown Shape: '..self.shape_name..' for '..obj.name)
    end
   
    if self.is_passive then
        collider:setPassive(self.shape)
    end

    for i,group in ipairs(self.groups) do
        collider:addToGroup(group, self.shape)
    end
end

local CollisionComponent = class({})
function CollisionComponent:init(collider, layer, obj, comp_data)
    -- TODO: Maybe give error if no position?

    -- builds the collision info for the component
    
    build_shape(self, collider, layer, obj, comp_data)

    local cx, cy = self.shape:center()
    self.sensors = {}
    

    comp_data.sensors = comp_data.sensors or {}
    for i, sensor_data in ipairs(comp_data.sensors) do
        local sensor = {}
        sensor_data.x = sensor_data.rel_x + cx
        sensor_data.y = sensor_data.rel_y + cy
        sensor_data.groups = _.extend(sensor_data.groups, comp_data.groups)
        build_shape(sensor, collider, layer, sensor_data, sensor_data)

        sensor.shape.is_sensor = true

        sensor.rel_x = sensor_data.rel_x
        sensor.rel_y = sensor_data.rel_y
        -- table.insert(self.sensors, sensor)
        self.sensors[sensor_data.name] = sensor
    end

end




return CollisionComponent