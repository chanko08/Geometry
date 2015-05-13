local LevelState 				= class({})

local PlayerInput 				= require('playerInput')

LevelState:include(PlayerInput)

function LevelState:init()
	self.level = 0
end

function LevelState:enter(previous, menuState)
	self.menu = menuState
end

function LevelState:update(dt)

end

function LevelState:draw()
	love.graphics.setColor(255,255,255)
    love.graphics.print('LEVEL STATE',30,30)
end

function LevelState:enterMenu()
	GameState.push(self.menu)
end

return LevelState
