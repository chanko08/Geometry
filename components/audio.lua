local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')

local AudioComponent = class({})
function AudioComponent:init(layer,obj,comp_data)
    -- Pretty unexciting. Just copying the list of event/sound pairs.
    for k,v in pairs(comp_data) do
        self[k] = v
    end
end

return AudioComponent