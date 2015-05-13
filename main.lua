class							= require('lib.hump.class')

GameState 						= require('lib.hump.gamestate')
local Camera					= require('lib.hump.camera')

local LevelState				= require('states.levelState')
local MenuState					= require('states.menuState')

function love.load()
	GameState.registerEvents()
	GameState.switch(LevelState,MenuState)
end

function love.draw()

end

function love.update(dt)

end
