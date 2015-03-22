local System  = require('systems.system')
local Vector  = require('lib.hump.vector')


local function render(input, bullet)
    local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(255*math.random(),255*math.random(),255*math.random())
        local t = love.timer.getTime()
        love.graphics.circle('fill',bullet.physics.s.x, bullet.physics.s.y, bullet.bullet.size + 3*love.math.randomNormal() , 50)
        
    love.graphics.setColor(r,g,b,a)
end

local BulletRenderer = class({})
BulletRenderer:include(System)

function BulletRenderer:init(manager)
    System.init(self,manager)
end

function BulletRenderer:run( )
    for i,ent in ipairs(self:get_entities('bullet')) do
        render(self.input, ent)
    end
end


function BulletRenderer:build_component( ... )
    -- print(inspect(...))
end

return BulletRenderer