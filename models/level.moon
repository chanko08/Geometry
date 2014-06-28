inspect = require 'lib/inspect'
Player  = require 'models/player'
Wall    = require 'models/wall'
HC      = require 'lib/HardonCollider'



class LevelModel
    new: (lvl) =>

        on_collision = (dt, A, B, mx, my) ->
            @on_collision(dt, A, B, mx, my)

        on_stop_collision = (dt, A, B) ->
            @on_stop_collision(dt, A, B)

        love.physics.setMeter 32
        @physics_world  = love.physics.newWorld 0, 9.81 * 32, true
        @collider = HC(100, on_collision, on_stop_collision)
        @width  = lvl.width
        @height = lvl.height
        @models = {}
        for i, layer in ipairs lvl.layers
            if layer.type != 'objectgroup'
                continue

            for j, obj in ipairs layer.objects
                @_add_model obj
    
    _add_model: (obj) =>
        if not @models[obj.name]
            @models[obj.name] = {}

        constructor = nil
        if obj.name == 'player'
            constructor = Player
        elseif obj.name == 'wall'
            constructor = Wall

        if constructor
            table.insert(@models[obj.name], constructor(obj, @physics_world, @collider))

    update: (dt) =>
        @physics_world\update dt

        [m\update dt for m in *@models['player']]
        [m\update dt for m in *@models['wall']]

    move_player: (direction) =>
        [m\move direction for m in *@models['player']]

    jump_player: =>
        [m\jump! for m in *@models['player']]

    stop_jump_player: =>
        [m\stop_jump! for m in *@models['player']]

    on_collision: (dt, A, B, mx, my) =>
        print('collided', inspect(A), inspect(B))

    on_stop_collision: (dt, A, B) =>
        print('stopped')

return LevelModel
