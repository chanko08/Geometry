inspect = require('lib.inspect')
class   = require 'lib.hump.class'
_       = require 'lib.underscore'
local Logger  = require 'utils.logger'


local State      = require('lib.hump.gamestate')
local LevelState = require('states.level')

function love.load(args)
    local settings = require('settings')
    print(inspect(args))
    logger = Logger(_.slice(args, 2, #args))
    logger:log('mom-joke', "yo momma is so fat, she needs a boomerang to put her belt on")
    love.mouse.setVisible(false)
    love.window.setMode(settings.DISPLAY_WIDTH, settings.DISPLAY_HEIGHT, settings.WINDOW_OPTIONS)

    State.registerEvents()
    local start_level = settings.START_LEVEL

    State.switch(LevelState, State, start_level)
end