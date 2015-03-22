local InputSystem = require 'hardware.input'

local GamepadHardware = class({})
GamepadHardware:include(InputSystem)



function GamepadHardware:init(state)
	InputSystem.init(self, state)

	local settings = require 'settings'
	self.gamepad_map  = settings.CONTROLS.gamepad
    self.gamepad = nil	
end

function GamepadHardware:run( dt )
	-- body
	InputSystem.run(self, dt)
    if self.gamepad ~= nil then
        local gp_x = self.gamepad:getGamepadAxis('rightx')
        local gp_y = self.gamepad:getGamepadAxis('righty')

        if gp_x*gp_x + gp_y*gp_y > (0.25)*(0.25) then
            self.aim_x = self.camera_system.target_position.x + 100*gp_x
            self.aim_y = self.camera_system.target_position.y + 100*gp_y
        else
            self.aim_x = self.camera_system.target_position.x + 100
            self.aim_y = self.camera_system.target_position.y + 0
        end

        self.direction = self.gamepad:getGamepadAxis('leftx')
    end    
end


function GamepadHardware:joystickadded(gamepad)
    self.gamepad = gamepad
    print('VIBES? ', gamepad:isVibrationSupported())
end

function GamepadHardware:gamepadpressed(gamepad,button)
    self:press_event(self.gamepad_map[button])
end

function GamepadHardware:gamepadreleased(gamepad,button)
    self:release_event(self.gamepad_map[button])
end

function GamepadHardware:gamepadaxis(gamepad,axis,value)
    if gamepad ~= nil and self.gamepad == gamepad then
        if axis == "triggerright" or axis == "triggerleft" then
            if value >= 0.5 and self[self.gamepad_map[axis]] == false then
                self:press_event(self.gamepad_map[axis])
            elseif value < 0.5 and self[self.gamepad_map[axis]] == true then
                self:release_event(self.gamepad_map[axis])
            end
        end
    end
end


return GamepadHardware