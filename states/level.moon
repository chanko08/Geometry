inspect     = require('lib/inspect')
_           = require('lib/underscore')
Camera      = require('lib/hump/camera')

Renderer    = require('renderers/simple')

State       = require('state')
Constants   = require('constants')

Level       = require('models/level')




---------------------------------------
-- Level Sate
class LevelState
    new: (lvlfile) =>
        lvlpath = 'lvls/'
        lvl = love.filesystem.load lvlpath .. lvlfile
        print('here')
        print(Level lvl!)
        @model = Level lvl!
        @renderer = Renderer @model


    update: (dt) =>
        @model\update dt
        @renderer\update dt


    draw: =>
        @renderer\draw @model


    keypressed: (key) =>
        if key == 'left'
            @model\move_player Constants.Direction.LEFT
        elseif key == 'right'
            @model\move_player Constants.Direction.RIGHT
        elseif key == ' '
            @model\jump_player!

    mousepressed: (x,y,button) =>
        if button == 'l' -- that's an L as in LEFT
            x, y = @renderer\world_coords(x,y)
            @model\shoot_gun(x,y)
        elseif button == 'r'
            print '-- Right mouse DOWN'
        elseif button == 'm'
            print '-- Middle mouse DOWN'


    mousereleased: (x,y,button) =>
        if button == 'l' -- that's an L as in LEFT
            print '-- Left mouse UP' 
        elseif button == 'r'
            print '-- Right mouse UP'
        elseif button == 'm'
            print '-- Middle mouse UP'


    keyreleased: (key) =>
        if key == 'left' or key == 'right'
            @model\move_player Constants.Direction.STOP
        elseif key == ' '
            @model\stop_jump_player!



return LevelState
