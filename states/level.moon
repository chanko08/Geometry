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
        if key == 'a'
            @model\move_player Constants.Direction.LEFT
        elseif key == 'd'
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
        elseif button == 'wd'
            print '-- Wheel DOWN'
            @renderer\zoomOut!
        elseif button == 'wu'
            print '-- Wheel UP'
            @renderer\zoomIn!
        else
            print 'Other button: ', button


    mousereleased: (x,y,button) =>
        if button == 'l' -- that's an L as in LEFT
            print '-- Left mouse UP' 
        elseif button == 'r'
            print '-- Right mouse UP'
        elseif button == 'm'
            print '-- Middle mouse UP'

    keyreleased: (key) =>
        if key == 'a' and love.keyboard.isDown('d')
            @model\move_player Constants.Direction.RIGHT
        elseif key == 'd' and love.keyboard.isDown('a')
            @model\move_player Constants.Direction.LEFT
        elseif key == 'a' or key == 'd'
            @model\move_player Constants.Direction.STOP
        elseif key == ' '
            @model\stop_jump_player!



return LevelState
