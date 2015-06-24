class							= require('lib.hump.class')
_                               = require('lib.underscore')
inspect                         = require('lib.inspect')
vector                          = require('lib.hump.vector')

-- Add the big always used functions to the namespace
local funcs = { 
    'map',
    'reduce',
    'filter',
    'head',
    'tail',
    'push',
    'pop',
    'keys',
    'values',
    'compose',
    'curry'
}

for i,f in ipairs(funcs) do
    _G[f] = _[f]
end

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
