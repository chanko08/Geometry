LevelState = require 'states/level'


settings =
    DISPLAY_WIDTH:  800
    DISPLAY_HEIGHT: 600
    WINDOW_OPTIONS: { fullscreen: false }

    -- STARTING_STATE: LevelState
    STARTING_STATE: LevelState
    START_LEVEL:    'notiles.lua'

return settings
