Constants = require 'constants'
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

        @ax = direction * @player.walk_accel
        if direction != Constants.Direction.STOP
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
                @ax = direction * @ax * 0.5 -- slow on turn around
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
            print "ACCEL: #{@ax}"
    
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

    new: (player_object, collider) =>
        @x = player_object.x
        @y = player_object.y

        @properties = player_object.properties
        @width        = 32
        @height       = 32
        --@max_velocity = 500
        @walk_accel   = 500
        @hasCollided  = false

        @scale_y      = 1

        @jump_speed   = 400
        @max_jumps    = 2
        @num_jumps    = 0

        @collider     = collider

        @collider_shape = collider\addPolygon( @x + 0.5*@width, @y, @x + @width, @y + 0.5*@height, @x + 0.5*@width, @y + @height, @x, @y + 0.5*@height )
        @collider_shape.model = @

        @tweens = { }
        
        print('direction?', Constants.Direction.RIGHT)
        @state = PlayerModelStandState(@, nil, nil, Constants.Direction.RIGHT)
        print('initial state facing', @state.facing)


    update: (dt) =>
        for k,tw in pairs(@tweens)
            tw\update(dt)

        x, y = @collider_shape\center!
        -- print "(#{x},#{y})" 
        @x = x - @width/2
        @y = y - @height/2

        @state\update(dt)

        @collider_shape\move @state.vx * dt, @state.vy * dt


    move: (direction) =>
        @state\move(direction)


    jump: =>
        @state\jump!

    stop_jump: =>
        @state\stop_jump!

    collide: (dt, A, B, mx, my) =>
        @state\collide dt, A, B, mx, my
        -- print mx, my
        -- if mx*mx + my*my < 0.5
        --     mx = 0
        --     my = 0

        -- @collider_shape\move mx, my
    switch_state: (next_state, ...) =>

        print('switching from', @state.__class.__name, 'to', next_state.__class.__name)
        print('facing', @state.facing)
        --print(...)
        @state = next_state(...) 
        print('facing', @state.facing)

return PlayerModel
