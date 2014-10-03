inspect       = require('lib/inspect')
_             = require('lib/underscore')
Camera        = require('lib/hump/camera')

Renderer      = require('renderers/simple')

State         = require('state')
Constants     = require('constants')

Level         = require('models/level')
SystemManager = require('managers/system_manager')

PhysicsSystem = require('systems/physics_system')

---------------------------------------
-- Level Sate
class LevelState extends SystemManager
    new: (lvlfile) =>
        super!

        physics = PhysicsSystem(@)

        -- print inspect(@connections)
        
        lvlpath = 'lvls/'
        lvl = love.filesystem.load lvlpath .. lvlfile
        
        @model = Level(@,lvl!)
        @renderer = Renderer @model


    update: (dt) =>
        systems = @\get_connection_hubs('update')
        for i,system in ipairs(systems)
            print 'System: ', system.__class
            system\update(@entity_manager,dt)


        -- @model\update dt
        @renderer\update dt

        -- for k,system in ipairs(@systems)
        --     system\update(dt)


    draw: =>
        @renderer\draw @model


    keypressed: (key) =>
        if key == 'a'
            @model\move_player Constants.Direction.LEFT
        elseif key == 'd'
            @model\move_player Constants.Direction.RIGHT
        elseif key == ' '
            @model\move_player Constants.Direction.UP

    mousepressed: (x,y,button) =>
        if button == 'l' -- that's an L as in LEFT
            x, y = @renderer\world_coords(x,y)
            @model\pull_gun_trigger(x,y)
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
            x, y = @renderer\world_coords(x,y)
            @model\release_gun_trigger(x,y)
        elseif button == 'r'
            print '-- Right mouse UP'
        elseif button == 'm'
            print '-- Middle mouse UP'

    keyreleased: (key) =>
        if key == 'a'
            @model\stop_move_player Constants.Direction.LEFT
        elseif key == 'd'
            @model\stop_move_player Constants.Direction.RIGHT
        elseif key == ' '
            @model\stop_move_player Constants.Direction.UP



return LevelState
