local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')

local CameraComponent = class({})

function CameraComponent:init(layer, obj, comp_data)
    self.target        = comp_data.target or nil
    self.lag_factor    = comp_data.lag_factor or 4
    self.target_entity = nil
end

return CameraComponent
