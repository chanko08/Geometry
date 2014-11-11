inspect = require('lib.inspect')
class   = require 'lib.hump.class'


local State      = require('lib.hump.gamestate')
local LevelState = require('states.level')

function love.load()
    local settings = require('settings')
    love.mouse.setVisible(false)
    love.window.setMode(settings.DISPLAY_WIDTH, settings.DISPLAY_HEIGHT, settings.WINDOW_OPTIONS)

    State.registerEvents()
    State.switch(LevelState, State, settings.START_LEVEL)
end