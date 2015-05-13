local PlayerInput				= class({})

local Input 					= require('input')

PlayerInput:include(Input)

function PlayerInput:init(joysticks)
	self.joysticks = joysticks
end

function PlayerInput:keypressed(key)
    -- if key == 'escape'	then love.event.quit() end
    -- if key == ' '		then self:enterMenu() end
end

function PlayerInput:keyreleased(key)
    if key == 'escape'	then love.event.quit() end
    if key == ' '		then self:enterMenu() end
end

return PlayerInput
