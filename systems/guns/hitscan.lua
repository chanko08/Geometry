local System             = require 'systems.system'
local HitScanGunComponent = require 'components.guns.hitscan'
local HC                 = require 'lib.HardonCollider'
local Vector             = require 'lib.hump.vector'

-- vector  = require 'lib.hump.vector'

local HitScanGunSystem = class({})
HitScanGunSystem:include(System)

function HitScanGunSystem:init( manager, input )
    System.init(self,manager)

    manager:register('hitscan_gun', self)
    manager:register('player', self)

    self.input = input
end

function HitScanGunSystem:run( dt )
    player = nil
    for i,ent in ipairs(self.entities:items()) do
        if not ent.hitscan_gun then
            player = ent
        end
    end


    for i,ent in ipairs(self.entities:items()) do
        if ent.hitscan_gun then
            ent.physics.s = player.physics.s + Vector(20,0)
            if self.input.main_trigger then
                ent.hitscan_gun.is_visible = true
            end

            if ent.hitscan_gun.is_visible then
                ent.hitscan_gun.visibility_delay = ent.hitscan_gun.visibility_delay - dt
            end
        end
    end
end

function HitScanGunSystem:build_component( layer, obj, comp_data )
    return HitScanGunComponent(layer, obj, comp_data)
    
end

return HitScanGunSystem