local InputSystem = require 'hardware.input'

local KeyboardMouseHardware = class({})
KeyboardMouseHardware:include(InputSystem)

function KeyboardMouseHardware:init(state)
	InputSystem.init(self, state)

	local settings = require 'settings'
	self.keyboard_map = settings.CONTROLS.keyboard
    self.mouse_map    = settings.CONTROLS.mouse
	
end

function KeyboardMouseHardware:run( dt )
    InputSystem.run(self, dt)
    self.aim_x, self.aim_y = self.camera_system:mouse_world_coords()
end


function KeyboardMouseHardware:keypressed(key)
    self:press_event(self.keyboard_map[key])
end

function KeyboardMouseHardware:keyreleased(key)
    self:release_event(self.keyboard_map[key])
end

function KeyboardMouseHardware:mousepressed(x,y,button)
    self:press_event(self.mouse_map[button])
end

function KeyboardMouseHardware:mousereleased(x,y,button)
    self:release_event(self.mouse_map[button])
end

return KeyboardMouseHardware