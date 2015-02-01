local LevelState = require('states/level')
local settings = {
    DISPLAY_WIDTH = 800,
    DISPLAY_HEIGHT = 600,
    WINDOW_OPTIONS = {
        fullscreen = false
    },
    STARTING_STATE = LevelState,
    START_LEVEL = 'simple2.lua',
    CONTROLS = {
        aim_controller = 'mouse',
        keyboard = {
            w = 'up',
            a = 'left',
            s = 'down',
            d = 'right',
            [" "] = 'jump',
            e = 'use'
        },
        mouse = {
            l  = 'fire',
            m  = 'zoom',
            r  = 'alt_fire',
            wd = 'inv_next',
            wu = 'inv_prev'
        },
        gamepad = {
        }
    }
}
return settings
