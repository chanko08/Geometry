Hub         = require 'hub'

Constants   = require 'constants'
Bullet      = require 'models/bullet'
SamusCannon = require 'models/guns/samus_cannon'

inspect     = require 'lib/inspect'
_           = require 'lib/underscore'
tween       = require 'lib/tween'
vector      = require 'lib/hump/vector'

physics     = require 'systems/physics_system'


export * 


class PlayerModel extends Hub

    new: (player_object, level, id) =>
        super(level.level_state.entity_manager)
        @id = id
        @model_type = 'player'

        physics   = {}
        physics.s = vector(player_object.x, player_object.y)
        physics.v = vector(0,0)
        physics.a = vector(0,Constants.GRAVITY)

        @physics  = @\register('physics', physics)
        

        shape_info         = {}
        shape_info.shape   = 'circle'
        shape_info.s       = @physics.s
        shape_info.radius  = @width/2
        shape_info.entity  = @
        shape_info.groups  = {'player'}
        shape_info.passive = false

        @collider_shape = @\register('collision', shape_info)



        @direction = Constants.Direction.RIGHT

        @jump_dur = 0

        @properties = player_object.properties
        @width        = 32
        @height       = 32
        --@max_velocity = 500
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

        -- @collider_shape = @collider\addPolygon( @x + 0.5*@width, @y, @x + @width, @y + 0.5*@height, @x + 0.5*@width, @y + @height, @x, @y + 0.5*@height )
        -- @collider_shape = @collider\addCircle(@physics.s.x, @physics.s.y, @width/2)
        -- @collider\addToGroup('player',@collider_shape)
        -- @collider_shape.model = @

        @collision =
            hasCollided: false
            mx: 0
            my: 0

        @tweens = { }

        @equipped_gun_index = nil
        @backpack = {}
        @backpack.guns = {}
        -- print inspect(SamusCannon)
        -- table.insert(@backpack.guns, SamusCannon(@))


    get_equipped_gun: () =>
        return @backpack.guns[@equipped_gun_index]
        
    update: (dt) =>

        player_gun = @\get_equipped_gun()
        if player_gun
            player_gun\update(dt)

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

    pull_gun_trigger:(cross_x, cross_y) =>
        if @equipped_gun_index
            @\get_equipped_gun()\pull_trigger({x: cross_x, y:cross_y})

    release_gun_trigger: (cross_x, cross_y) =>
        if @equipped_gun_index
            @\get_equipped_gun()\release_trigger({x: cross_x, y:cross_y})

    collide: (dt, player_physics, other_physics, mx, my) =>
        @collision.hasCollided = true
        @collision.mx += mx
        @collision.my += my

    stop_collide: (...) =>

    damage: (...) =>

    get_center: =>
        return @collider_shape\center!


return PlayerModel
