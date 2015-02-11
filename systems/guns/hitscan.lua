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

            local mouse = Vector(self.input.aim_x, self.input.aim_y)

            ent.hitscan_gun.aim_direction = mouse - ent.physics.s
            ent.hitscan_gun.aim_direction:normalize_inplace()
            ent.physics.rot = ent.hitscan_gun.aim_direction:angleTo()

            if self.input.main_trigger then
                print('PEW PEW PEW!')
                ent.hitscan_gun.firing = true
                ent.hitscan_gun.fire_position  = ent.physics.s
                ent.hitscan_gun.fire_direction = ent.hitscan_gun.aim_direction
            end

            if ent.hitscan_gun.firing then
                ent.hitscan_gun.visibility_delay = math.max(ent.hitscan_gun.visibility_delay - dt,0.0)
            end

            if ent.hitscan_gun.visibility_delay <= 0 then
                ent.hitscan_gun.firing = false
                ent.hitscan_gun.visibility_delay = 1.0
            end
        end
    end
end

function HitScanGunSystem:build_component( layer, obj, comp_data )
    return HitScanGunComponent(layer, obj, comp_data)
end

return HitScanGunSystem