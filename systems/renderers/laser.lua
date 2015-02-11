local System  = require 'systems.system'

local function render(gun)
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(255,0,255)
        local origin_x, origin_y = gun.fire_position:unpack()
        local end_x, end_y       = (gun.fire_position + 1000*gun.fire_direction):unpack()
        local old_width = love.graphics.getLineWidth()
        love.graphics.setLineWidth(gun.visibility_delay * 15)
        love.graphics.line(origin_x,origin_y,end_x,end_y)
        love.graphics.setLineWidth(old_width)
    love.graphics.setColor(r,g,b,a)
end

local LaserRenderer = class({})
LaserRenderer:include(System)

function LaserRenderer:init( manager)
    System.init(self,manager)
    manager:register('hitscan_gun', self)
end

function LaserRenderer:run( )
    for i,ent in ipairs(self.entities:items()) do
        if ent.hitscan_gun and ent.hitscan_gun.firing then
            render(ent.hitscan_gun)
        end
    end
end


function LaserRenderer:build_component( ... )
    -- print(inspect(...))
end

return LaserRenderer