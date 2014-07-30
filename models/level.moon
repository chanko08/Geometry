inspect = require 'lib/inspect'
Player  = require 'models/player'
Bullet  = require 'models/bullet'
Wall    = require 'models/wall'
HC      = require 'lib/HardonCollider'
_       = require 'lib/underscore'

debug_count_refs = (tbl, tbl_name) ->
    c = 0
    for i,p in pairs tbl
        c = c + 1
    print "DEBUG: table #{tbl_name} has #{c} keys"

class LevelModel
    new: (lvl) =>
        @next_id = 1

        on_collision = (dt, A, B, mx, my) ->
            @on_collision(dt, A, B, mx, my)

        on_stop_collision = (dt, A, B) ->
            @on_stop_collision(dt, A, B)

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
        elseif obj.name == 'bullet'
            constructor = Bullet

        if constructor
            -- table.insert(@models[obj.name], constructor(obj, @, @next_id))
            @models[obj.name][@next_id] = constructor(obj, @, @next_id)
            @next_id += 1

    update: (dt) =>
        @collider\update dt
        --@physics_world\update dt

        for model_name, model_list in pairs @models
            for id,m in pairs model_list
                if m then m\update dt

        debug_count_refs(@\get_models('bullet'), 'bullet')
        

        -- [m\update dt for m in *@models['player']]
        -- [m\update dt for m in *@models['wall']]


    move_player: (direction) =>
        for id, m in pairs @\get_models('player')
            m\move direction

        -- {m\move direction for id,m in pairs @models['player'] when m}

    shoot_gun: (x,y) =>
        for id, m in pairs @\get_models('player')
            m\shoot(x,y)
        -- {m\shoot(x,y) for id,m in pairs @models['player'] when m}

    jump_player: =>
        for id, m in pairs @\get_models('player')
            m\jump!
        -- {m\jump! for id,m in pairs @models['player'] when m}

    stop_jump_player: =>
        for id, m in pairs @\get_models('player')
            m\stop_jump!
        -- {m\stop_jump! for id,m in pairs @models['player'] when m}

    on_collision: (dt, A, B, mx, my) =>
        -- _.map(@models['player'], (p) -> p\collide(dt, A, B, mx, my))

        print dt
        print "\tA - #{A.model.model_type}"
        if B.model
            print "\tB - #{B.model.model_type}"

        A.model\collide(dt, A, B, mx, my)
        -- B.model\collide(dt, A, B, mx, my)

    on_stop_collision: (dt, A, B) =>

    get_models: (model_name) =>
        if @models[model_name]
            return @models[model_name]
        return {}

    remove_model: (model_name, model_id) =>
        if not @models[model_name]
            error "WTF is a #{model_name} model type?!?!?!!11"
            return

        if not @models[model_name][model_id]
            error "WTF: found model with invalid id -- #{model_name}, #{model_id}"

        -- table.remove(@models[model_name], model_id)
        @models[model_name][model_id] = nil


return LevelModel

