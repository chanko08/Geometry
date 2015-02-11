local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')

local HitScanComponent = class({})

function HitScanComponent:init( layer, obj, comp_data )
    self.visibility_delay = 1
    self.firing           = false
    self.aim_direction    = nil
    self.fire_position    = nil
    self.fire_direction   = nil
end

return HitScanComponent