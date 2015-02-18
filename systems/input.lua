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
    
    self.direction = 0
    self.v_direction = 0
    
    self.main_trigger_delta = false
    self.main_trigger = false
    self.main_trigger_prev = false

    self.alt_trigger_delta = false
    self.alt_trigger  = false
    self.alt_trigger_prev = false

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
    else
        error('Not here yet...')
    end



    self.main_trigger_delta = self.main_trigger ~= self.main_trigger_prev
    self.main_trigger_prev = self.main_trigger

    

    self.alt_trigger_delta = self.main_trigger ~= self.main_trigger_prev
    self.alt_trigger_prev = self.alt_trigger
    
end

function InputSystem:keypressed(key)
    local k = self.keyboard_map[key]

    -- only non-nil if used key
    if     k == 'up' then
        self.v_direction = 1
    elseif k == 'down' then
        self.v_direction = -1
    elseif k == 'left' then
        self.direction = -1
    elseif k == 'right' then
        self.direction = 1
    elseif k == 'jump' then
        self.jump = true
    elseif k == 'use' then
        self.use = true
    end
end

function InputSystem:keyreleased(key)
    local k = self.keyboard_map[key]

    -- only non-nil if used key
    if     k == 'up'    and self.v_direction == 1 then
        self.v_direction = 0
    elseif k == 'down'  and self.v_direction == -1 then
        self.v_direction = 0
    elseif k == 'left'  and self.direction   == -1 then
        self.direction = 0
    elseif k == 'right' and self.direction   ==  1 then
        self.direction = 0
    elseif k == 'jump' then
        self.jump = false
    elseif k == 'use' then
        self.use = false
    end
end

function InputSystem:mousepressed(x,y,button)
    if     button == 'l' then
        self.main_trigger = true
    elseif button == 'r' then
        self.alt_trigger = true
    elseif button == 'm' then
        self.weapon_zoom = true
    elseif button == 'wd' then
        self.inv_direction = -1
    elseif button == 'wu' then
        self.inv_direction = 1
    else
        print('Unknown button: '..button)
    end
end

function InputSystem:mousereleased(x,y,button)
    if     button == 'l' then
        self.main_trigger = false
    elseif button == 'r' then
        self.alt_trigger = false
    elseif button == 'm' then
        self.weapon_zoom = false
    elseif button == 'wd' then
        -- self.inv_direction = 0
    elseif button == 'wu' then
        -- self.inv_direction = 0
    else
        print('Unknown button: '..button)
    end
end

function InputSystem:joystickpressed(x,y,button)

end

function InputSystem:joystickreleased(x,y,button)
    -- body
end

return InputSystem