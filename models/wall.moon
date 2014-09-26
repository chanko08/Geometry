inspect = require 'lib/inspect'
_       = require 'lib/underscore'

class WallModel
    new: (wall_object, level, id) =>
        @id = id
        @model_type = 'wall'

        @x          = wall_object.x
        @y          = wall_object.y
        @shape_name = wall_object.shape
        @properties = wall_object.properties
        @level      = level
        @collider   = @level.collider
        
        @collider_shapes = nil

        if @shape_name == 'rectangle'
            @width  = wall_object.width
            @height = wall_object.height

            @collider_shapes = {@collider\addRectangle(@x, @y, @width, @height)}
            


        elseif @shape_name == 'ellipse'
            @width  = wall_object.width
            if @width <= 0 then @width = 14
            @collider_shapes = {@collider\addCircle(@x, @y, @width)}

        elseif @shape_name == 'polyline'
            -- Translate the relative-to-start coordinates
            -- to normal coords
            @vertices = [{x: pt.x + @x, y: pt.y + @y} for pt in *wall_object.polyline ]

            @lines = [{@vertices[i], @vertices[i+1]} for i = 1,#@vertices - 1 ]

            @vertices = [c for v in *@vertices for c in *{v.x, v.y}]

            -- Create a triangle that closely approximates a line
            -- as HardonCollider does not have line collision objects
            create_line = (L) ->
                @collider\addPolygon(L[1].x, L[1].y, L[2].x, L[2].y, (L[1].x + L[2].x) * 0.5, (L[1].y + L[2].y) * 0.5 + .001)

            @collider_shapes = _.map(@lines, create_line)

        elseif @shape_name = 'polygon'
            @vertices = [{pt.x + @x, pt.y + @y} for pt in *wall_object.polygon ]
            @vertices  = [c for v in *@vertices for c in *v]

            @collider_shapes = {@collider\addPolygon(unpack @vertices)}

        else
            error 'Unknown shape!'

        for k, shape in ipairs @collider_shapes
            shape.model = @
            @collider\setPassive shape

    update: (dt) =>

    collide: (...) =>

    stop_collide: (...) =>
