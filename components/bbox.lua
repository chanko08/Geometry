local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')

local BoundingBoxComponent = class({})
function BoundingBoxComponent:init( obj, comp_data )
    -- TODO: Maybe give error if no position?
    
    local dim = Vector(obj.width, obj.height) or Vector(0, 0)

    
    self.dim = dim
end

return BoundingBoxComponent