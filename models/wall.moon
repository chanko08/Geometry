inspect = require 'lib/inspect'
_       = require 'lib/underscore'

class WallModel
    new: (wall_object, world, collider) =>
        @x          = wall_object.x
        @y          = wall_object.y
        @shape_name = wall_object.shape
        @properties = wall_object.properties

        if @shape_name == 'rectangle'
            @width  = wall_object.width
            @height = wall_object.height

            box = collider\addRectangle @x, @y, @width, @height
            collider\setPassive box

            @body   = love.physics.newBody  world,
                                            @x - @width/2,
                                            @y - @height/2,
                                            'static'

            @physics_shape = love.physics.newRectangleShape @width, @height

        elseif @shape_name == 'ellipse'
            @width  = wall_object.width
            if @width <= 0 then @width = 14

            circle = collider\addCircle @x, @y, @width
            collider\setPassive circle

            @body   = love.physics.newBody  world,
                                            @x,
                                            @y,
                                            'static'

            @physics_shape = love.physics.newCircleShape(@x, @y, @width)

        elseif @shape_name == 'polyline'
            -- Translate the relative-to-start coordinates
            -- to normal coords
            @vertices = [{x: pt.x + @x, y: pt.y + @y} for pt in *wall_object.polyline ]

            @lines = [{@vertices[i], @vertices[i+1]} for i = 1,#@vertices - 1 ]

            @physics_vertices = [c for v in *@vertices for c in *{v.x, v.y}]

            -- Create a triangle that closely approximates a line
            -- as HardonCollider does not have line collision objects
            create_line = (L) ->
                line = collider\addPolygon(L[1].x, L[1].y, L[2].x, L[2].y, L[1].x, L[1].y + .001)
                collider\setPassive line

            _.map(@lines, create_line)

            @physics_shape = love.physics.newChainShape(false, unpack @physics_vertices)
            @body   = love.physics.newBody  world,
                                            @x,
                                            @y,
                                            'static'

        elseif @shape_name = 'polygon'
            @vertices = [{pt.x + @x, pt.y + @y} for pt in *wall_object.polygon ]


            @vertices = [c for v in *@vertices for c in *v]

            polygon = collider\addPolygon(unpack @vertices)
            collider\setPassive polygon

            @physics_shape = love.physics.newChainShape(true, unpack @vertices)
            @body   = love.physics.newBody  world,
                                            @x,
                                            @y,
                                            'static'

        else
            error 'Unknown shape!'

        
        @fixture = love.physics.newFixture(@body, @physics_shape)

    update: (dt) =>



