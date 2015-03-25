local System = require 'systems.system'

local ReticleRenderer = class({})
ReticleRenderer:include(System)

function ReticleRenderer:init(state)
    System.init(self,state)
end

function ReticleRenderer:run()
    local aim_x = self.input.aim_x
    local aim_y = self.input.aim_y

    local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(255,0,255) -- Hawkguy special
        love.graphics.line(aim_x - 3, aim_y, aim_x + 3, aim_y)
        love.graphics.line(aim_x, aim_y - 3, aim_x, aim_y + 3)
    love.graphics.setColor(r,g,b,a)
end

return ReticleRenderer