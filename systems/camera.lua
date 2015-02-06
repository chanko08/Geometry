local System             = require 'systems.system'
local CameraComponent    = require 'components.camera'
local HC                 = require 'lib.HardonCollider'
local Vector             = require 'lib.hump.vector'
local HumpCamera         = require 'lib.hump.camera'

-- vector  = require 'lib.hump.vector'

local CameraSystem = class({})
CameraSystem:include(System)

function CameraSystem:init( manager, state, renderers,pre_renderers,post_renderers )
    System.init(self,manager)
    manager:register('camera', self)
    self.camera = HumpCamera(0,0)

    self.state = state

    self.renderers      = renderers
    self.pre_renderers  = pre_renderers
    self.post_renderers = post_renderers
    --manager:register('sensors', self)

    
end

function CameraSystem:run( dt )
    local target = _.first(self.entities:items())

    if not target.camera.lag_factor then
        self.camera:lookAt(target.physics.s:unpack())
    else
        local px, py = target.physics.s:unpack()
        local dx, dy = px - self.camera.x, py - self.camera.y
        self.camera:move( dt * dx * target.camera.lag_factor,
                          dt * dy * target.camera.lag_factor)
    end 
end


function CameraSystem:build_component( layer, obj, comp_data )
    return CameraComponent(layer, obj, comp_data)
end

function CameraSystem:draw()
    for i,renderer in ipairs(self.pre_renderers) do
        renderer:run()
    end
    self:attach()
    for i,renderer in ipairs(self.renderers) do
        renderer:run()
    end
    self:detach()
    for i,renderer in ipairs(self.post_renderers) do
        renderer:run()
    end
    self:draw_reticle()
end

function CameraSystem:attach()
    self.camera:attach()
end

function CameraSystem:detach()
    self.camera:detach()
end

function CameraSystem:to_world_coords(x,y)
    return self.camera:worldCoords(x,y)
end

function CameraSystem:to_camera_coords(x,y)
    return self.camera:cameraCoords(x,y)
end

function CameraSystem:mouse_world_coords()
    local mx, my = love.mouse.getPosition()

    return self.camera:worldCoords(mx,my)
end

function CameraSystem:draw_reticle()
    local aim_x, aim_y = love.mouse.getPosition()

    local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(255,0,255) -- Hawkguy special
        love.graphics.line(aim_x - 3, aim_y, aim_x + 3, aim_y)
        love.graphics.line(aim_x, aim_y - 3, aim_x, aim_y + 3)
    love.graphics.setColor(r,g,b,a)
end

return CameraSystem