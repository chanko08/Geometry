class WallModel
    new: (wall_object, world) =>
        @x          = wall_object.x
        @y          = wall_object.y
        @shape      = wall_object.shape
        @properties = wall_object.properties

        @body   = love.physics.newBody  world,
                                        @x - @width/2,
                                        @y - @height/2,
                                        'static'

        if @shape == 'rectangle'
            @width  = wall_object.width
            @height = wall_object.height

            @physics_shape = love.physics.newRectangleShape @width @height

        elseif @shape == 'ellipse'
            @width  = wall_object.width
            if @width <= 0 then @width = 14

            @physics_shape = love.physics.newCircleShape(@x, @y, @width)

        elseif @shape == 'polyline'
            -- Translate the relative-to-start coordinates
            -- to normal coords
            @vertices = [{pt.x + @x, pt.y + @y} for pt in wall_object.polyline ]
            @vertices = [c for c in v for v in vertices]

            @physics_shape = love.physics.newChainShape(false, unpack @vertices)

        elseif @shape = 'polygon'
            @vertices = [{pt.x + @x, pt.y + @y} for pt in wall_object.polyline ]
            @vertices = [c for c in v for v in vertices]

            @physics_shape = love.physics.newChainShape(true, unpack @vertices)

        else 
            error 'Unknown shape!'

        @fixture = love.physics.newFixture(@body, @physics_shape)

    update: (dt) =>
        @x = @body\getX!
        @y = @body\getY!



