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
    print(inspect(args))
    print(args[2])
    if args[2] then
        start_level = args[2]
        print('changed level to: ' .. args[2])
    end

    print(inspect(settings))
    print(start_level)
    State.switch(LevelState, State, start_level)
end