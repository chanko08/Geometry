class WallModel
    new: (wall_object, world) =>
        @x          = wall_object.x
        @y          = wall_object.y
        @shape      = wall_object.shape
        @properties = wall_object.properties

        if @shape == 'rectangle'
            @width  = wall_object.width
            @height = wall_object.height

            @body   = love.physics.newBody  world,
                                            @x - @width/2,
                                            @y - @height/2,
                                            'static'

            @physics_shape = love.physics.newRectangleShape @width, @height

        elseif @shape == 'ellipse'
            @width  = wall_object.width
            if @width <= 0 then @width = 14

            @body   = love.physics.newBody  world,
                                            @x,
                                            @y,
                                            'static'

            @physics_shape = love.physics.newCircleShape(@x, @y, @width)

        elseif @shape == 'polyline'
            -- Translate the relative-to-start coordinates
            -- to normal coords
            @vertices = [{pt.x + @x, pt.y + @y} for pt in *wall_object.polyline ]
            @vertices = [c for v in *@vertices for c in *v]

            @physics_shape = love.physics.newChainShape(false, unpack @vertices)
            @body   = love.physics.newBody  world,
                                            @x,
                                            @y,
                                            'static'

        elseif @shape = 'polygon'
            @vertices = [{pt.x + @x, pt.y + @y} for pt in *wall_object.polygon ]
            @vertices = [c for v in *@vertices for c in *v]

            @physics_shape = love.physics.newChainShape(true, unpack @vertices)
            @body   = love.physics.newBody  world,
                                            @x,
                                            @y,
                                            'static'

        else
            error 'Unknown shape!'

        
        @fixture = love.physics.newFixture(@body, @physics_shape)

    update: (dt) =>
        @x = @body\getX!
        @y = @body\getY!



