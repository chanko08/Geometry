local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')

local CollisionComponent = class({})
function CollisionComponent:init(collider, layer, obj, comp_data)
    -- TODO: Maybe give error if no position?
    
    self.shape_name = comp_data.shape or obj.shape 
    
    -- We might want to change this later... assumption is
    -- that there will be more walls and static objects than
    -- dynamic ones...
    if comp_data.is_passive ~= nil then
        self.is_passive = comp_data.is_passive
    else
        self.is_passive = true
    end


    self.group          = comp_data.group or layer.name or 'NO GROUP: '..obj.name
    
    self.has_collided   = false
    self.resolve_vector = Vector(0,0)


    if self.shape_name == 'rectangle' then
        self.shape = collider:addRectangle(obj.x, obj.y, obj.width, obj.height)
        self.shape.component = self

        collider:addToGroup(self.group, self.shape)
        if self.is_passive then
            collider:setPassive(self.shape)
            print(self.group)
        end

        self.offset = Vector(obj.width / 2, obj.height / 2)
    elseif self.shape_name == 'circle' then
        self.shape = collider:addCircle(obj.x, obj.y, obj.width / 2)
        self.shape.component = self

        collider:addToGroup(self.group, self.shape)
        if self.is_passive then
            collider:setPassive(self.shape)
            print(self.group)
        end

        self.offset = Vector(obj.width / 2, obj.height / 2)
    else
        error('Unknown Shape: '..self.shape_name..' for '..obj.name)
    end

end

return CollisionComponent