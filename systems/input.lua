local System             = require 'systems.system'
local Vector             = require 'lib.hump.vector'

local InputSystem = class({})
InputSystem:include(System)

function InputSystem:init(entity_manager, camera)
    local settings = require('settings')

    self.camera_system = camera

    self.aimer        = settings.CONTROLS.aim_controller
    self.keyboard_map = settings.CONTROLS.keyboard
    self.mouse_map    = settings.CONTROLS.mouse
    self.gamepad_map  = settings.CONTROLS.gamepad

    self.gamepad = nil
    
    self.direction = 0
    self.v_direction = 0
    
    self.main_trigger_delta = false
    self.main_trigger = false
    self.main_trigger_prev = false

    self.alt_trigger_delta = false
    self.alt_trigger  = false
    self.alt_trigger_prev = false

    self.aim_x = 0
    self.aim_y = 0

    self.weapon_zoom  = false
    self.target = {}
    self.jump = false
    self.use  = false
    self.inv_direction = 0
end

function InputSystem:run(dt)
    if self.aimer == 'mouse' then
        self.aim_x, self.aim_y = self.camera_system:mouse_world_coords()
        -- TODO: save a look direction?
    elseif self.aimer == 'gamepad' then
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

    

    self.main_trigger_delta = self.main_trigger ~= self.main_trigger_prev
    self.main_trigger_prev = self.main_trigger

    

    self.alt_trigger_delta = self.main_trigger ~= self.main_trigger_prev
    self.alt_trigger_prev = self.alt_trigger
    
end

function InputSystem:keypressed(key)
    self:press_event(self.keyboard_map[key])
end

function InputSystem:keyreleased(key)
    self:release_event(self.keyboard_map[key])
end

function InputSystem:mousepressed(x,y,button)
    self:press_event(self.mouse_map[button])
end

function InputSystem:mousereleased(x,y,button)
    self:release_event(self.mouse_map[button])
end

function InputSystem:joystickadded(gamepad)
    self.gamepad = gamepad
end

function InputSystem:gamepadpressed(gamepad,button)
    self:press_event(self.gamepad_map[button])
end

function InputSystem:gamepadreleased(gamepad,button)
    self:release_event(self.gamepad_map[button])
end

function InputSystem:gamepadaxis(gamepad,axis,value)
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

function InputSystem:press_event(event)
    if     event == 'up' then
        self.v_direction = 1
    elseif event == 'down' then
        self.v_direction = -1
    elseif event == 'left' then
        self.direction = -1
    elseif event == 'right' then
        self.direction = 1
    elseif event == 'jump' then
        self.jump = true
    elseif event == 'use' then
        self.use = true
    elseif event == 'main_trigger' then
        self.main_trigger = true
    elseif event == 'alt_trigger' then
        self.alt_trigger = true
    elseif event == 'zoom' then
        self.weapon_zoom = true
    elseif event == 'inv_prev' then
        self.inv_direction = -1
    elseif event == 'inv_next' then
        self.inv_direction = 1
    end
end

function InputSystem:release_event(event)
    if     event == 'up'    and self.v_direction == 1 then
        self.v_direction = 0
    elseif event == 'down'  and self.v_direction == -1 then
        self.v_direction = 0
    elseif event == 'left'  and self.direction   == -1 then
        self.direction = 0
    elseif event == 'right' and self.direction   ==  1 then
        self.direction = 0
    elseif event == 'jump' then
        self.jump = false
    elseif event == 'use' then
        self.use = false
    elseif event == 'main_trigger' then
        self.main_trigger = false
    elseif event == 'alt_trigger' then
        self.alt_trigger = false
    elseif event == 'zoom' then
        self.weapon_zoom = false
    elseif event == 'inv_prev' then
        -- self.inv_direction = 0
    elseif event == 'inv_next' then
        -- self.inv_direction = 0
    end
end

return InputSystem