Constants = require 'constants'

class PlayerModel
    new: (player_object, world) =>
        @x = player_object.x
        @y = player_object.y
        @properties = player_object.properties
        @width = 32
        @height = 32
        @max_velocity = 500
        @walk_accel = 500

        @jump_speed = 200
        @max_jumps = 2
        @num_jumps = 0

        @body = love.physics.newBody world            ,
                                     @x - @width / 2  ,
                                     @y - @height / 2 ,
                                     'dynamic'

        @physics_shape = love.physics.newRectangleShape @x, @y, @width, @height
        @fixture = love.physics.newFixture @body, @physics_shape, 1
        @state = PlayerModelStandState(@)

    update: (dt) =>
        @x = @body\getX! 
        @y = @body\getY!
        @state\update(dt)


    move: (direction) =>
        @state\move(direction)


    jump: =>
        @state\jump!


    stop_jump: =>
        @state\stop_jump!


-------------------------------------
-- PlayerModelState
class PlayerModelState
    initialize: (player) =>
        @player = player


    move: (direction) =>


    jump: =>


    stop_jump: =>
        vx, vy = @player.body\getLinearVelocity!
        if vy < 0 then
            @player.body\setLinearVelocity vx, 0
            @player.num_jumps = 0

    update: (dt) =>



---------------------------------------
---- PlayerModelStandState
class PlayerModelStandState extends PlayerModelState
    move: (direction) =>
        super(direction)
        @player.state = PlayerModelWalkState @player, direction



    jump: =>
        super!
        @player.state = PlayerModelJumpState @player, Constants.Direction.STOP


    stop_jump: =>
        super!
        PlayerModelState.stop_jump @
        @player.state = PlayerModelStandState @player


---------------------------------------
---- PlayerModelWalkState
class PlayerModelWalkState extends PlayerModelStandState
    initialize: (player, direction) =>
        super(player)
        @direction = direction

        @vx, @vy = @player.body\getLinearVelocity!
        @x, @y   = @player.body\getPosition!
    
        currentSign = (@vx == 0) and 0 or ((@vx > 0) and 1 or -1) -- sign(vx)
        @acc = @player.walk_accel * @direction

        if currentSign ~= 0 and currentSign ~= @direction 
            @acc = @acc * 0.5 -- slow on turn around
        
    



    move: (direction) =>
        super(direction)
        if direction == 0
            vx, vy = @player.body\getLinearVelocity!
            @player.body\setLinearVelocity 0, vy
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
        super(dt)
        @vx = @vx + @acc * dt

        @vx = (@vx >  @player.max_velocity) and  @player.max_velocity or @vx
        @vx = (@vx < -@player.max_velocity) and -@player.max_velocity or @vx

        -- print(@vx, @vy)

        @player.body\setLinearVelocity(@vx, @vy)
        -- @player.body:setPosition(@x + dt*@vx, @y+dt*@vy)



---------------------------------------
---- PlayerModelJumpState
class PlayerModelJumpState extends PlayerModelWalkState
    new: (player, direction) =>
        super(player, direction)

        if math.abs(@vy) < .001 and @player.num_jumps <= @player.max_jumps
            @vy = -@player.jump_speed
            @player.num_jumps = @player.num_jumps + 1
    



    move: (direction) =>
        super(direction)
        if direction == 0
            vx, vy = @player.body\getLinearVelocity!
            @player.body\setLinearVelocity 0, vy
            @player.state = PlayerModelStandState @player
        else
            @player.state = PlayerModelJumpState @player, direction
    


    jump: () =>
        @player.state = PlayerModelJumpState @player, @direction


    stop_jump: () =>
        super!
        @player.state = PlayerModelWalkState @player, @direction



