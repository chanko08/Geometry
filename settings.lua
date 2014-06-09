LevelState = require('states/level')
local settings = {}

settings.DISPLAY_WIDTH  = 0
settings.DISPLAY_HEIGHT = 0
settings.WINDOW_OPTIONS = {fullscreen = true}

settings.STARTING_STATE = LevelState
settings.START_LEVEL    = 'notiles.lua'

return settings
