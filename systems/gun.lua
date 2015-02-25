local System  = require 'systems.system'
local GunComponent = require 'components.gun'


local GunSystem = class({})
GunSystem:include(System)

function GunSystem:init( manager, input )
    System.init(self,manager)
    manager:register('gun', self)
    self.input = input

end

function GunSystem:run( dt )
    -- check input for if we're pulling trigger
    --if just fired
    local guns = self:get_entities('gun')
    if self.input.main_trigger_delta and self.input.main_trigger then
        --initializing pull trigger tweens
        for i, ent in ipairs(guns) do
            ent.gun.current_tweens = {}

            for k,tween in pairs(ent.gun.pull_trigger) do
                ent.gun.current_tweens[k] = tween
                tween:reset(ent.gun)
            end
        end
    --elseif gun trigger was just released
    elseif self.input.main_trigger_delta and not self.input.main_trigger then
        print(self.input.main_trigger_duration)
        --initializing release trigger tweens
        for i, ent in ipairs(guns) do
            ent.gun.current_tweens = {}

            for k,tween in pairs(ent.gun.release_trigger) do
                ent.gun.current_tweens[k] = tween
                tween:reset(ent.gun)
            end
        end
    end

    --update tweens, if they're done remove them from queue
    for i, ent in ipairs(guns) do

        for k,tween in pairs(ent.gun.current_tweens) do
            if not tween:finished() then
                print('the fuck')
                tween:update(dt)
            else
                ent.gun.current_tweens[k] = nil
            end
        end
    end

    for i, ent in ipairs(guns) do
        print(inspect(ent.gun.spin_speed))    
    end
end


function GunSystem:build_component( ... )
    print('build GunSystem components')
    return GunComponent(...)
end

return GunSystem