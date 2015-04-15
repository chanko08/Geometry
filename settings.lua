local LevelState = require('states/level')
local settings = {
    DISPLAY_WIDTH = 800,
    DISPLAY_HEIGHT = 600,
    WINDOW_OPTIONS = {
        fullscreen = false
    },
    STARTING_STATE = LevelState,
    START_LEVEL = 'simple2.lua',
    AUDIO = {
        SFX_VOLUME   = 1,
        MUSIC_VOLUME = 0
    },
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
            l  = 'main_trigger',
            m  = 'zoom',
            r  = 'alt_trigger',
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
