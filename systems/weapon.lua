local System = require 'systems.system'
local WeaponComponent = require 'components.weapon'

local WeaponSystem = class({})
WeaponSystem:include(System)

function WeaponSystem:init( manager )
    System.init(self,manager)
    -- open and load weapon data
    manager:register('weapon', self)  
end

function WeaponSystem:run( dt )
    for i,ent in ipairs(self.entities:items()) do
        print('derp')
    end
end

function WeaponSystem:build_component( ... )
    return WeaponComponent(...)
end

return WeaponSystem