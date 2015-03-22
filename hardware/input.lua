local System             = require 'systems.system'
local Vector             = require 'lib.hump.vector'

local InputSystem = class({})
InputSystem:include(System)

function InputSystem:init(state, entity_manager)
    local settings = require('settings')

    self.camera_system = state.camera

    -- self.aimer        = settings.CONTROLS.aim_controller

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
    self.main_trigger_delta = self.main_trigger ~= self.main_trigger_prev
    self.main_trigger_prev = self.main_trigger

    self.alt_trigger_delta = self.main_trigger ~= self.main_trigger_prev
    self.alt_trigger_prev = self.alt_trigger
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

function InputSystem:keypressed(key)
end

function InputSystem:keyreleased(key)
end

function InputSystem:mousepressed(x,y,button)
end

function InputSystem:mousereleased(x,y,button)
end


function InputSystem:joystickadded(gamepad)
end

function InputSystem:gamepadpressed(gamepad,button)
end

function InputSystem:gamepadreleased(gamepad,button)
end

function InputSystem:gamepadaxis(gamepad,axis,value)
end



return InputSystem