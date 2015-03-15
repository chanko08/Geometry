local System  = require('systems.system')
local Vector  = require('lib.hump.vector')


local function render(input, gun)
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(255,0,255)
        local origin_x, origin_y = gun.fire_position:unpack()
        local end_x, end_y       = (gun.fire_position + 1000*Vector(input.aim_x-origin_x, input.aim_y-origin_y):normalized()):unpack()
        local old_width = love.graphics.getLineWidth()
        
        if gun.visibility_delay>=0.001 then
            if input.gamepad ~= nil then
                local successQ = input.gamepad:setVibration(gun.visibility_delay,gun.visibility_delay,gun.visibility_delay)
                -- print('Vibration applied successfully: ', successQ)
            end
            love.graphics.setLineWidth(50*gun.visibility_delay)
            love.graphics.line(origin_x,origin_y,end_x,end_y)
            love.graphics.setLineWidth(old_width)
        end
    love.graphics.setColor(r,g,b,a)
end

local LaserRenderer = class({})
LaserRenderer:include(System)

function LaserRenderer:init(manager, player_input)
    System.init(self,manager)
    self.input = player_input
    --manager:register('hitscan_gun', self)
end

function LaserRenderer:run( )
    for i,ent in ipairs(self:get_entities('gun')) do
        render(self.input, ent.gun)
    end
end


function LaserRenderer:build_component( ... )
    -- print(inspect(...))
end

return LaserRenderer