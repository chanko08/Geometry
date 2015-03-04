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
        gamepad_sensitivity = 1.0,
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
            a            = 'jump',
            triggerright = 'main_trigger',
            triggerleft  = 'alt_trigger',

        }
    }
}
return settings
