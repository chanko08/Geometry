local System  = require 'systems.system'


local BBoxRenderer = class({})
BBoxRenderer:include(System)

function BBoxRenderer:init( manager )
    System.init(self,manager)
    manager:register('bbox', self)
end

function BBoxRenderer:run( )
    
    
    for i,ent in ipairs(self.entities:items()) do
        local s = ent.physics.s
        local w,h = ent.bbox.dim:unpack()

        r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(255,255,255)
            love.graphics.rectangle('line',s.x,s.y,w,h)
        love.graphics.setColor(r,g,b,a)
    end
    
end

return BBoxRenderer