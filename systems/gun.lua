local System  = require 'systems.system'
local Vector = require('lib.hump.vector')

local GunComponent = require 'components.gun'


local GunSystem = class({})
GunSystem:include(System)

function GunSystem:init( state )
    System.init(self,state)
end

function GunSystem:run( dt )
    local player = _.first(self:get_entities('player'))

    local guns = self:get_entities('gun')

    for i, ent in ipairs(guns) do
        ent.physics.s = player.physics.s + Vector(20,0)
        ent.physics.rot = ent.gun.aim_direction:angleTo()
    end

    for i,ent in ipairs(guns) do
        local gun = ent.gun
        
        if self.input.main_trigger_delta then
            if self.input.main_trigger then
                print('PULLING')
                gun.gun_state:enter(gun.pull_trigger_state)
            else
                print('RELEASING')
                gun.gun_state:enter(gun.release_trigger_state)
                gun.burst = 0
            end
        end

        if gun.gun_state.state == gun.pull_trigger_state or gun.gun_state.state == gun.fire_bullet_state then
            if gun.fire_delay <= 0 and gun.burst < gun.max_burst then
                gun.burst = gun.burst + 1
                print('FIRING: ',gun.burst)
                gun.fire_position = player.physics.s
                gun.gun_state:enter(gun.fire_bullet_state)
                -- self.camera:shake(20, 2)
                if self.input.gamepad ~= nil then
                    local successQ = self.input.gamepad:setVibration(gun.vibration_strength,gun.vibration_strength,gun.vibration_duration)
                    -- print('Vibration applied successfully: ', successQ)
                end

                self.relay:emit('fire',ent)

            end
        elseif gun.gun_state.state == gun.release_trigger_state then
            gun.gun_state:enter(gun.at_rest_state)
            -- print('RETURNING TO REST')
        end        

        gun:update(dt)
    end
end


function GunSystem:build_component( ... )
    return GunComponent(...)
end

return GunSystem