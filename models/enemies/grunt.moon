Constants   = require 'constants'
GruntAI     = require 'models/enemies/gruntai'
Sensor      = require 'models/sensor'

inspect     = require 'lib/inspect'
_           = require 'lib/underscore'
tween       = require 'lib/tween'

physics = require 'systems/physics'

export *

class Grunt
    new: (grunt_object, level, id) =>
        @id = id
        @model_type = 'grunt'

        @x = grunt_object.x
        @y = grunt_object.y
        @vx = 0
        @vy = 0
        @ax = 0
        @ay = Constants.GRAVITY

        @direction = Constants.Direction.RIGHT

        @jump_dur = 0


        @properties = grunt_object.properties
        @width        = 32
        @height       = 32
        @walk_accel   = 1500
        @jump_walk_accel_mod = 0.5
        @max_jump_duration = .1

        @hasCollided  = false

        @scale_y      = 1

        @jump_speed   = 400
        @max_jumps    = 2
        @num_jumps    = 0

        @collider     = level.collider
        @level        = level

        @health       = 100

        @collider_shape = @collider\addCircle(@x,@y,@width/2)
        @collider\addToGroup('grunt',@collider_shape)        
        @collider_shape.model = @

        target_player = (phys) -> phys.model.model_type == 'player'
        target_wall   = (phys) -> phys.model.model_type == 'wall' 

        @sensors =
            player_visible: Sensor(@, target_player, 'grunt', {name:'player_visible', shape:'ellipse',  width:200})
            cliff_right:    Sensor(@, target_wall,   'grunt', {name:'cliff_right',    shape:'rectangle', x:15,  y:0, width:1, height:80})
            cliff_left:     Sensor(@, target_wall,   'grunt', {name:'cliff_left',     shape:'rectangle', x:-16, y:0, width:1, height:80})

        @collision =
            hasCollided: false
            mx: 0
            my: 0

        @tweens = { }

        @ai = GruntAI(@)

    update: (dt) =>

        if @collision.hasCollided
            @collision.hasCollided = false
            @collider_shape\move @collision.mx, @collision.my
            @x += @collision.mx
            @y += @collision.my

            if @jump_dur <= 0
                @vy = 0

        for k,tw in pairs(@tweens)
            tw\update(dt)


        phys_x =
            x:  @x
            vx: @vx
            ax: @ax

        phys_y =
            x:  @y
            vx: @vy
            ax: @ay

        
        if @jump_dur > 0
            phys_y.ax = 0
            @jump_dur -= dt
        else
            @jump_dur = 0
            phys_y.ax = Constants.GRAVITY

        

        phys_x = physics(phys_x, dt, Constants.MAX_VELOCITY)
        phyx_y = physics(phys_y, dt, Constants.MAX_VELOCITY)

        @x = phys_x.x
        @y = phys_y.x

        @vx = phys_x.vx
        @vy = phys_y.vx

        @update_collider!
        @collision.mx = 0
        @collision.my = 0
        
        @ai\update(dt)

        for k, sensor in pairs @sensors
            sensor\update (dt)

        --check if we're in the air

    update_collider: () =>
        @collider_shape\moveTo (@x + @width * 0.5), (@y + @height * 0.5)

    move: (direction) =>
        --@move_state\move direction 
        if direction == Constants.Direction.LEFT
            @ax = -@walk_accel
            @direction = direction
        elseif direction == Constants.Direction.RIGHT
            @ax = @walk_accel
            @direction = direction
        elseif direction == Constants.Direction.UP
            @y -= 10
            @vy = -@jump_speed
            @jump_dur = @max_jump_duration

    stop_move: (direction) =>
        if direction == Constants.Direction.LEFT or direction == Constants.Direction.RIGHT
            if direction == @direction
                @ax = 0
                @vx = 0

        elseif direction == Constants.Direction.UP and @jump_dur > 0
            @ay = Constants.GRAVITY
            @vy = 0
            @jump_dur = 0

    -- pull_gun_trigger:(cross_x, cross_y) =>
    --     if @equipped_gun_index
    --         @\get_equipped_gun()\pull_trigger({x: cross_x, y:cross_y})

    -- release_gun_trigger: (cross_x, cross_y) =>
    --     if @equipped_gun_index
    --         @\get_equipped_gun()\release_trigger({x: cross_x, y:cross_y})

    collide: (dt, grunt_physics, other_physics, mx, my) =>
        @collision.hasCollided = true
        @collision.mx += mx
        @collision.my += my

    stop_collide: (...) =>

    damage: (dmg_info) =>
        

        @health -= dmg_info.damage
        print "I'm HIT! MEDIC!!!", @health

    get_center: =>
        return @collider_shape\center!