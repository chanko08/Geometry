local Input						= class({})

function Input:init(joysticks)
	self.joysticks = joysticks
end

function Input:keypressed(key)
    -- if key == 'escape'	then love.event.quit() end
    -- if key == ' '		then GameState.push(self.menu) end
end

function Input:keyreleased(key)
    -- if key == 'escape'	then love.event.quit() end
    -- if key == ' '		then self:enterMenu() end
end

return Input
