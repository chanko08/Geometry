local System             = require 'systems.system'
local CameraComponent    = require 'components.camera'
local HC                 = require 'lib.HardonCollider'
local Vector             = require 'lib.hump.vector'
local HumpCamera         = require 'lib.hump.camera'
local ShakeSystem        = require 'systems.shake'

local Tween              = require 'utils.tween'

local CameraSystem = class({})
CameraSystem:include(System)

function CameraSystem:init( state, renderers, pre_renderers, post_renderers )
    System.init(self,state)

    self.shake_system  = ShakeSystem(state)

    self:add_subsystem(self.shake_system)

    self.cam             = HumpCamera(0,0)
    self.target_position = {x=0, y=0}

    self.state = state

    self.renderers      = renderers      or {}
    self.pre_renderers  = pre_renderers  or {}
    self.post_renderers = post_renderers or {}
end

function CameraSystem:run( dt )
    System.run(self,dt)
    if self.shake_tween then
        self.shake_tween:update(dt)
    end

    local target = _.first(self:get_entities('camera'))
    self.target_position = target.physics.s

    if not target.camera.lag_factor then
        self.cam:lookAt(target.physics.s:unpack())
    else
        local px, py = target.physics.s:unpack()
        local dx, dy = px - self.cam.x, py - self.cam.y
        self.cam:move( dt * dx * target.camera.lag_factor, dt * dy * target.camera.lag_factor)
        self.cam:move( self.shake_system.shake_offset:unpack() )
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
end

function CameraSystem:add_renderer(renderer)
    table.insert(self.renderers, renderer)
end

function CameraSystem:add_pre_renderer(renderer)
    table.insert(self.pre_renderers, renderer)
end

function CameraSystem:add_post_renderer(renderer)
    table.insert(self.post_renderers, renderer)
end

function CameraSystem:attach()
    self.cam:attach()
end

function CameraSystem:detach()
    self.cam:detach()
end

function CameraSystem:to_world_coords(x,y)
    return self.cam:worldCoords(x,y)
end

function CameraSystem:to_camera_coords(x,y)
    return self.cam:cameraCoords(x,y)
end

function CameraSystem:mouse_world_coords()
    local mx, my = love.mouse.getPosition()

    return self.cam:worldCoords(mx,my)
end

-- function  CameraSystem:shake( intensity, duration )
--     local angle = math.random(0,math.pi)
--     self.shake_direction = Vector(1,0):rotated(angle)
--     self.shake_intensity = intensity
--     local tween_info = {
--         duration=duration,
--         type="outElastic",
--         target=0,
--         start=intensity
--     }
--     self.shake_tween = Tween("shake_intensity", tween_info, self)
--     self.shake_tween:reset()
-- end

return CameraSystem