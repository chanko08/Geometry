LevelState = require 'states/level'

settings =
    DISPLAY_WIDTH:  640
    DISPLAY_HEIGHT: 480
    WINDOW_OPTIONS: { fullscreen: false }

    -- STARTING_STATE: LevelState
    STARTING_STATE: LevelState
    START_LEVEL:    'notiles.lua'

return settings
