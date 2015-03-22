local System  = require 'systems.system'
local Vector = require('lib.hump.vector')

local GunComponent = require 'components.gun'


local GunSystem = class({})
GunSystem:include(System)

function GunSystem:init( manager, input, bullet_system )
    System.init(self,manager)
    manager:register('gun', self)
    self.input = input
    self.bullet_system = bullet_system

end

function GunSystem:run( dt )
    -- check input for if we're pulling trigger
    --if just fired
    local player = _.first(self:get_entities('player'))

    local guns = self:get_entities('gun')

    for i, ent in ipairs(guns) do
        ent.physics.s = player.physics.s + Vector(20,0)
        ent.physics.rot = ent.gun.aim_direction:angleTo()
    end

    for i,ent in ipairs(guns) do
        local gun = ent.gun

        -- print('state: '..gun.gun_state.state.name, gun.fire_delay)
        
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

                self.bullet_system:create_bullet(ent)

            elseif gun.gun_state.state == gun.release_trigger_state then
                gun.gun_state:enter(gun.at_rest_state)
                -- print('RETURNING TO REST')
            end
        end        

        gun:update(dt)
    end
end


function GunSystem:build_component( ... )
    return GunComponent(...)
end

return GunSystem