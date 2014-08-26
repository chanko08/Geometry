Constants = require 'constants'
Bullet    = require 'models/bullet'

inspect   = require 'lib/inspect'
_         = require 'lib/underscore'
tween     = require 'lib/tween'


export * 

walk_step = (state, dt) ->
    vx = state.vx + state.ax * dt

    vx = (vx >  Constants.MAX_VELOCITY) and  Constants.MAX_VELOCITY or vx
    vx = (vx < -Constants.MAX_VELOCITY) and -Constants.MAX_VELOCITY or vx

    -- print "VX: #{vx} AX: #{state.ax}"
    return vx


physics_integration = (phys_obj, dt, max_velocity) ->
    max_velocity = max_velocity or Constants.MAX_VELOCITY

    vx = phys_obj.vx + phys_obj.ax * dt
    vx = (vx >  max_velocity) and  max_velocity or vx
    vx = (vx < -max_velocity) and -max_velocity or vx

    px = phys_obj.x + vx * dt


    phys_obj.vx = vx
    phys_obj.x = px
    return phys_obj


-- walk_direction = (direction, wall) ->


-------------------------------------
-- PlayerModelState
class PlayerModelState
    new: (player, facing) =>
        @player = player
        
        @vx = 0
        @vy = 0
        @ax = 0
        @ay = 0

        @facing = facing
        @direction = Constants.Direction.RIGHT


    move: (direction) =>


    jump: =>

    collide: (dt, A, B, mx, my) =>


    stop_jump: =>

    update: (dt) =>




---------------------------------------
---- PlayerModelStandState
class PlayerModelStandState extends PlayerModelState
    new: (player, wall, direction, facing) =>
        print('facing in stand state', facing)
        super player, facing
        print('facing in stand state', @facing)
        @wall = wall

    move: (direction) =>
        if direction != Constants.Direction.STOP
            @ax = direction * @player.walk_accel
            @facing = direction

            @player\switch_state(PlayerModelWalkState, @player, @vx, @vy, @ax, @ay, @wall, @facing)


    collide: (dt, A, B, mx, my) =>

        @player.hasCollided = true
        if A == @player.collider_shape
            @wall = B
        else
            @wall = A
        -- print inspect wall_direction()
        -- love.event.quit!

    jump: =>
        @vy = -@player.jump_speed
        @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay, @facing)

    update: (dt) =>
        if @player.hasCollided
            @player.hasCollided = false
        else
            @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay, @facing)

---------------------------------------
---- PlayerModelWalkState
class PlayerModelWalkState extends PlayerModelState
    new: (player, vx, vy, ax, ay, wall, facing) =>
        super player, facing

        --print "Args: ", vx, vy, ax, ay
        
        @vx = vx
        @vy = vy
        @ax = ax
        @ay = ay
        @wall = wall


    move: (direction) =>
        if direction == 0
            @player\switch_state(PlayerModelStandState, @player, nil, nil, @facing)
        else
            currentSign = (@vx == 0) and 0 or ((@vx > 0) and 1 or -1) -- sign(vx)
            --@player.acc = @player.walk_accel * @direction

            if currentSign != 0 and currentSign != direction
                @ax = direction * @ax -- slow on turn around
                @facing = direction
            
                @player\switch_state(PlayerModelWalkState, @player, @vx, @vy, @ax, @ay, nil, @facing)
    


    jump: () =>
        @vy = -@player.jump_speed
        @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay, @facing)


    update: (dt) =>
        if @player.hasCollided
            @player.hasCollided = false
            @vx = walk_step(@, dt)
        else
            @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay, @facing)


    collide: (dt, A, B, mx, my) => 
        @player.hasCollided = true
        if A == @player.collider_shape
            @wall = B
        else
            @wall = A
        @player.collider_shape\move mx, my
        -- print(@vx, @vy)


---------------------------------------
---- PlayerModelJumpState
class PlayerModelJumpState extends PlayerModelState
    new: (player, vx, vy, ax, ay, facing) =>
        super player, facing
        @vx = vx
        @vy = vy
        @ax = ax
        @ay = ay

        --if math.abs(@vy) < .001
        --@vy = -@player.jump_speed
        @hit_ground = false
        @just_jumped_duration = 1
    

    update: (dt) =>
        @vy += Constants.GRAVITY * dt 
        @vx = walk_step(@, dt)
        if @hit_ground
            print("hit the fucking ground: #{@ax}, #{@vx}, #{@vy}")

            if @vy > 100
                @player.scale_y = 1 - 0.5*(math.min(@vy/Constants.MAX_VELOCITY,1.25))
                @player.tweens.smush = tween.new(0.17, @player, {scale_y: 1.0}, "inBack")

            @vy = 0
            if @ax != 0
                @player\switch_state(PlayerModelWalkState, @player, @vx, @vy, @ax, @ay, @wall, @facing)
            else
                @player\switch_state(PlayerModelStandState, @player, @wall, nil, @facing)

    move: (direction) =>
        if direction == 0
            --@player\switch_state(PlayerModelStandState, @player)
            @vx = 0
            @ax = 0
        else
            print('Direction is: ', direction)
            --@player\switch_state(PlayerModelJumpState, @player, direction)
            currentSign = (@vx == 0) and 0 or ((@vx > 0) and 1 or -1) -- sign(vx)
            @ax = @player.walk_accel * direction

            @facing = direction

            if currentSign != 0 and currentSign != direction
                @ax = @ax * 0.5 -- slow on turn around
            -- print "ACCEL: #{@ax}"
    
    collide: (dt, A, B, mx, my) =>
        if @just_jumped_duration > 0
            @just_jumped_duration -= 1
            return

        @player.collider_shape\move mx, my

        if A == @player.collider_shape
            @wall = B
        else
            @wall = A

        if @vy > 0
            @hit_ground = true

    jump: () =>
        @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay, @facing)


    stop_jump: () =>
        @vy = 0

class PlayerModel

    new: (player_object, level, id) =>
        @id = id
        @model_type = 'player'

        @x = player_object.x
        @y = player_object.y
        @vx = 0
        @vy = 0
        @ax = 0
        @ay = Constants.GRAVITY

        @direction = Constants.Direction.RIGHT

        @jump_dur = 0


        @properties = player_object.properties
        @width        = 32
        @height       = 32
        --@max_velocity = 500
        @walk_accel   = 1500
        @jump_walk_accel_mod = 0.5
        @max_jump_duration = 3



        @hasCollided  = false

        @scale_y      = 1

        @jump_speed   = 400
        @max_jumps    = 2
        @num_jumps    = 0

        @collider     = level.collider
        @level        = level

        @collider_shape = @collider\addPolygon( @x + 0.5*@width, @y, @x + @width, @y + 0.5*@height, @x + 0.5*@width, @y + @height, @x, @y + 0.5*@height )
        @collider_shape.model = @

        @collision =
            hasCollided: false
            mx: 0
            my: 0

        @tweens = { }
        
    update: (dt) =>
        if @collision.hasCollided
            print "correcting..."
            @collision.hasCollided = false
            @collider_shape\move @collision.mx, @collision.my
            @x += @collision.mx
            @y += @collision.my


            if @jump_dur <= 0
                @vy = 0


            @update_collider!



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

        print dt
        if @jump_dur > 0
            phys_y.ax = 0
            @jump_dur -= dt

        

        phys_x = physics_integration(phys_x, dt)
        phyx_y = physics_integration(phys_y, dt)

        @x = phys_x.x
        @y = phys_y.x

        @vx = phys_x.vx
        @vy = phys_y.vx

        @update_collider!
        

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
            @vy = @jump_speed
            @jump_dur = @max_jump_duration

    stop_move: (direction) =>
        if direction == Constants.Direction.LEFT or direction == Constants.Direction.RIGHT
            if direction == @direction
                @ax = 0
                @vx = 0

    shoot:(xdir,ydir) =>
        cx, cy = @\get_center!
        bullet_data = {name:'bullet', radius:10, orig_x: cx, orig_y:cy, dir_x:xdir, dir_y:ydir, speed:1000}
        @level\_add_model(bullet_data)

    collide: (dt, player_physics, other_physics, mx, my) =>
        --@state\collide dt, A, B, mx, my
        --@vy = 0
        @collision.hasCollided = true
        @collision.mx = mx
        @collision.my = my
        





    get_center: =>
        return @collider_shape\center!


return PlayerModel
