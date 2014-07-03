Constants = require 'constants'
inspect   = require 'lib/inspect'
_         = require 'lib/underscore'


export * 

walk_step = (state, dt) ->
    vx = state.vx + state.ax * dt

    vx = (vx >  Constants.MAX_VELOCITY) and  Constants.MAX_VELOCITY or vx
    vx = (vx < -Constants.MAX_VELOCITY) and -Constants.MAX_VELOCITY or vx

    print "VX: #{vx} AX: #{state.ax}"
    return vx


-------------------------------------
-- PlayerModelState
class PlayerModelState
    new: (player) =>
        @player = player
        @vx = 0
        @vy = 0
        @ax = 0
        @ay = 0
        @direction = Constants.Direction.STOP


    move: (direction) =>


    jump: =>

    collide: (dt, A, B, mx, my) =>


    stop_jump: =>

    update: (dt) =>




---------------------------------------
---- PlayerModelStandState
class PlayerModelStandState extends PlayerModelState
    new: (player) =>
        super player

    move: (direction) =>
        @ax = direction * @player.walk_accel

        @player\switch_state(PlayerModelWalkState, @player, @vx, @vy, @ax, @ay)


    collide: (dt, A, B, mx, my) =>
        @player.hasCollided = true

    jump: =>
        @vy = -@player.jump_speed
        @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay)

    update: (dt) =>
        if @player.hasCollided
            @player.hasCollided = false
        else
            @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay)

---------------------------------------
---- PlayerModelWalkState
class PlayerModelWalkState extends PlayerModelState
    new: (player, vx, vy, ax, ay) =>
        super player

        print "Args: ", vx, vy, ax, ay
        
        @vx = vx
        @vy = vy
        @ax = ax
        @ay = ay    



    move: (direction) =>
        if direction == 0
            @player\switch_state(PlayerModelStandState, @player)
        else
            currentSign = (@vx == 0) and 0 or ((@vx > 0) and 1 or -1) -- sign(vx)
            --@player.acc = @player.walk_accel * @direction

            if currentSign != 0 and currentSign != direction
                @ax = direction * @ax * 0.5 -- slow on turn around
            
            @player\switch_state(PlayerModelWalkState, @player, @vx, @vy, @ax, @ay)
    


    jump: () =>
        @vy = -@player.jump_speed
        @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay)


    update: (dt) =>
        if @player.hasCollided
            @player.hasCollided = false
            @vx = walk_step(@, dt)
        else
            @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay)


    collide: (dt, A, B, mx, my) => 
        @player.hasCollided = true
        -- print(@vx, @vy)


---------------------------------------
---- PlayerModelJumpState
class PlayerModelJumpState extends PlayerModelState
    new: (player, vx, vy, ax, ay) =>
        super player
        @vx = vx
        @vy = vy
        @ax = ax
        @ay = ay

        --if math.abs(@vy) < .001
        --@vy = -@player.jump_speed
        @hit_ground = false
    

    update: (dt) =>
        @vy += Constants.GRAVITY * dt 
        @vx = walk_step(@, dt)
        if @hit_ground
            print("hit the fucking ground: #{@ax}, #{@vx}, #{@vy}")
            @vy = 0
            if @ax != 0
                @player\switch_state(PlayerModelWalkState, @player, @vx, @vy, @ax, @ay)
            else
                @player\switch_state(PlayerModelStandState, @player, @vx, @vy, @ax, @ay)

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


            if currentSign != 0 and currentSign != direction
                @ax = @ax * 0.5 -- slow on turn around
            print "ACCEL: #{@ax}"
    
    collide: (dt, A, B, mx, my) =>

        --if @vy > 0
        @player.collider_shape\move mx, my
        @hit_ground = true

    jump: () =>
        @player\switch_state(PlayerModelJumpState, @player, @vx, @vy, @ax, @ay)


    stop_jump: () =>
        @vy = 0




class PlayerModel

    new: (player_object, collider) =>
        @x = player_object.x
        @y = player_object.y
        @vx, @vy = 0,0
        @acc = 0

        @properties = player_object.properties
        @width        = 32
        @height       = 32
        --@max_velocity = 500
        @walk_accel   = 500
        @hasCollided  = false

        @jump_speed   = 400
        @max_jumps    = 2
        @num_jumps    = 0

        @collider     = collider

        @collider_shape = collider\addRectangle @x, @y, @width, @height
        @collider_shape.model = @
        
        @state = PlayerModelStandState @


    update: (dt) =>
        

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
        print(...)
        @state = next_state(...) 

return PlayerModel
