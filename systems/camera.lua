local System             = require 'systems.system'
local CameraComponent    = require 'components.camera'
local HC                 = require 'lib.HardonCollider'
local Vector             = require 'lib.hump.vector'
local HumpCamera         = require 'lib.hump.camera'

-- vector  = require 'lib.hump.vector'

local CameraSystem = class({})
CameraSystem:include(System)

function CameraSystem:init( manager )
    System.init(self,manager)
    manager:register('camera', self)
    self.camera = HumpCamera(0,0)
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

function CameraSystem:attach()
    self.camera:attach()
end

function CameraSystem:detach()
    self.camera:detach()
end

return CameraSystem