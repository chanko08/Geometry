Constants = require 'constants'


export * 

-------------------------------------
-- PlayerModelState
class PlayerModelState
    new: (player) =>
        @player = player
        @vx, @vy = 0, 0


    move: (direction) =>


    jump: =>

    collide: (dt, A, B, mx, my) =>


    stop_jump: =>

    update: (dt) =>




---------------------------------------
---- PlayerModelStandState
class PlayerModelStandState extends PlayerModelState
    move: (direction) =>
        super direction
        @player.state = PlayerModelWalkState @player, direction


    collide: (dt, A, B, mx, my) =>
        @player.hasCollided = true

    jump: =>
        super!
        @player.state = PlayerModelJumpState @player, Constants.Direction.STOP


    stop_jump: =>
        super!
        PlayerModelState.stop_jump @
        @player.state = PlayerModelStandState @player

    update: (dt) =>
        if @player.hasCollided
            @player.hasCollided = false
        else
            @player.state = PlayerModelJumpState @player, Constants.Direction.STOP

---------------------------------------
---- PlayerModelWalkState
class PlayerModelWalkState extends PlayerModelStandState
    new: (player, direction) =>
        super player
        @direction = direction
    
        currentSign = (@vx == 0) and 0 or ((@vx > 0) and 1 or -1) -- sign(vx)
        @acc = @player.walk_accel * @direction

        if currentSign != 0 and currentSign != @direction
            @acc = @acc * 0.5 -- slow on turn around
        
    



    move: (direction) =>
        super direction
        if direction == 0
            @player.state = PlayerModelStandState @player
        else
            @player.state = PlayerModelWalkState @player, direction
    


    jump: () =>
        super!
        @player.state = PlayerModelJumpState @player, @direction



    stop_jump: () =>
        super!
        @player.state = PlayerModelWalkState @player, @direction


    update: (dt) =>
        super dt
        @vx = @vx + @acc * dt

        @vx = (@vx >  @player.max_velocity) and  @player.max_velocity or @vx
        @vx = (@vx < -@player.max_velocity) and -@player.max_velocity or @vx

        -- print(@vx, @vy)


---------------------------------------
---- PlayerModelJumpState
class PlayerModelJumpState extends PlayerModelWalkState
    new: (player, direction) =>
        super player, direction

        if math.abs(@vy) < .001 and @player.num_jumps <= @player.max_jumps
            @vy = -@player.jump_speed
            @player.num_jumps = @player.num_jumps + 1
    

    update: (dt) =>
        @player.collider_shape\move 0, Constants.GRAVITY*dt

    move: (direction) =>
        super direction
        if direction == 0
            @player.state = PlayerModelStandState @player
        else
            @player.state = PlayerModelJumpState @player, direction
    
    collide: (dt, A, B, mx, my) =>
        @player.collider_shape\move mx/2, my/2
        @player.state = PlayerModelStandState @player

    jump: () =>
        @player.state = PlayerModelJumpState @player, @direction


    stop_jump: () =>
        super!
        @player.state = PlayerModelWalkState @player, @direction




class PlayerModel
    new: (player_object, collider) =>
        @x = player_object.x
        @y = player_object.y
        @properties = player_object.properties
        @width        = 32
        @height       = 32
        @max_velocity = 500
        @walk_accel   = 500
        @hasCollided  = false

        @jump_speed   = 200
        @max_jumps    = 2
        @num_jumps    = 0

        @collider_shape = collider\addRectangle @x, @y, @width, @height
        @collider_shape.model = @
        
        @state = PlayerModelStandState @

    update: (dt) =>
        x, y = @collider_shape\center!
        @x = x - @width/2
        @y = y - @height/2

        @state\update(dt)


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


return PlayerModel
