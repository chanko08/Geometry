local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')

local CameraComponent = class({})

function CameraComponent:init( obj, comp_data )
    self.lag_factor    = comp_data.lag_factor or 4
end

return CameraComponent
