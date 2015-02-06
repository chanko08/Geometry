local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')

local HitScanComponent = class({})

function HitScanComponent:init( layer, obj, comp_data )
    self.visibility_delay = 2000
    self.is_visible = false
end

return HitScanComponent