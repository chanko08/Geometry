inspect          = require('lib.inspect')
class            = require('lib.hump.class')
_                = require('lib.underscore')
log              = require('lib.log')

local State      = require('lib.hump.gamestate')
local LevelState = require('states.level')

function love.load(args)
    local settings = require('settings')
    love.mouse.setVisible(false)
    love.window.setMode(settings.DISPLAY_WIDTH, settings.DISPLAY_HEIGHT, settings.WINDOW_OPTIONS)

    State.registerEvents()
    local start_level = settings.START_LEVEL

    State.switch(LevelState, State, start_level)
end