local LevelState = require('states/level')
local settings = {
  DISPLAY_WIDTH = 800,
  DISPLAY_HEIGHT = 600,
  WINDOW_OPTIONS = {
    fullscreen = false
  },
  STARTING_STATE = LevelState,
  START_LEVEL = 'simple2.lua'
}
return settings
