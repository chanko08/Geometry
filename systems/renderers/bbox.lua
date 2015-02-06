local System  = require 'systems.system'
local BoundingBoxComponent = require 'components.bbox'

local function render(bbox)
        local r,g,b,a = love.graphics.getColor()
        if bbox.has_collided then 
            love.graphics.setColor(255,0,0)
        else
            love.graphics.setColor(255,255,255)
        end
        bbox.shape:draw() 
        love.graphics.setColor(r,g,b,a)
end

local BBoxRenderer = class({})
BBoxRenderer:include(System)

function BBoxRenderer:init( manager, state )
    System.init(self,manager)
    self.state = state
    manager:register('bbox', self)
end

function BBoxRenderer:run( )
    
    
    for i,ent in ipairs(self.entities:items()) do
        local s = ent.physics.s
        -- print(inspect(ent))
        -- print(inspect(ent))
        local cx,cy = ent.collision.shape:center() 
        local w,h = ent.bbox.dim:unpack()
        
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(255,255,255)
        love.graphics.rectangle('line',s.x,s.y,w,h)
        love.graphics.setColor(r,g,b,a)

        render(ent.collision)

        for k,sensor in pairs(ent.collision.sensors) do
            render(sensor)
        end

        --draw collision box
    end
end


function BBoxRenderer:build_component( ... )
    -- print(inspect(...))
    return BoundingBoxComponent(...)
end

return BBoxRenderer