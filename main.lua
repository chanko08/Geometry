inspect = require('lib.inspect')
class   = require 'lib.hump.class'


local State      = require('lib.hump.gamestate')
local LevelState = require('states.level')

function love.load(args)
    local settings = require('settings')
    love.mouse.setVisible(false)
    love.window.setMode(settings.DISPLAY_WIDTH, settings.DISPLAY_HEIGHT, settings.WINDOW_OPTIONS)

    State.registerEvents()
    local start_level = settings.START_LEVEL
    if args[2] then
        start_level = args[2]
    end
    State.switch(LevelState, start_level)
end