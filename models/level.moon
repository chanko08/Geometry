Player = require 'models/player'
Wall   = require 'models/wall'

class LevelModel
    new: (lvl) =>
        love.physics.setMeter 32
        @world  = love.physics.newWorld 0, 9.81 * 32, true
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
            table.insert @models[obj.name], constructor obj, @world

    update: (dt) =>
        @world\update dt

        [m\update dt for m in *@models['player']]
        [m\update dt for m in *@models['wall']]

    move_player: (direction) =>
        [m\move direction for m in *@models['player']]

    jump_player: =>
        [m\jump! for m in *@models['player']]

    stop_jump_player: =>
        [m\stop_jump! for m in *@models['player']]

return LevelModel
