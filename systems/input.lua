local System             = require 'systems.system'
local Vector             = require 'lib.hump.vector'

local InputSystem = class({})
InputSystem:include(System)

function InputSystem:init(...)
    local settings = require('settings')
    self.aimer        = settings.CONTROLS.aim_controller
    self.keyboard_map = settings.CONTROLS.keyboard
    self.mouse_map    = settings.CONTROLS.mouse
    self.gamepad_map  = settings.CONTROLS.gamepad
    
    self.direction = 0
    self.v_direction = 0
    self.main_trigger = false
    self.alt_trigger  = false
    self.jump = false
    self.use  = false
    self.inv_direction = 0
end

function InputSystem:run(dt)
    if self.aimer == 'mouse' then
        self.aim_x, self.aim_y = love.mouse.getPosition()
        -- TODO: save a look direction?
    else
        error('Not here yet...')
    end
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

end

function InputSystem:mousereleased(x,y,button)
    -- body
end

function InputSystem:joystickpressed(x,y,button)

end

function InputSystem:joystickreleased(x,y,button)
    -- body
end

return InputSystem