local MenuInput					= class({})

local Input 					= require('input')

MenuInput:include(Input)

function MenuInput:init(joysticks)
	self.joysticks = joysticks
end

function MenuInput:keypressed(key)
    -- if key == 'escape'	then love.event.quit() end
    -- if key == ' '		then self:exitMenu() end
end

function MenuInput:keyreleased(key)
    if key == 'escape'	then love.event.quit() end
    if key == ' '		then self:exitMenu() end
end

return MenuInput
