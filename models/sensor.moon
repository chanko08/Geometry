Constants   = require 'constants'

inspect     = require 'lib/inspect'
_           = require 'lib/underscore'
tween       = require 'lib/tween'


export *


class Sensor
	new: (model, collision_group, sensor_obj) =>
		@model = model

        @model_type = 'sensor'

        @x          = @model.x
        @y          = @model.y
        @shape_name = sensor_obj.shape
        print @shape_name
        @properties = sensor_obj.properties
        @collider   = @model.collider
        @collider_shape = nil

        @detected   = false

		if @shape_name == 'rectangle'
            @width  = sensor_obj.width
            @height = sensor_obj.height

            box = @collider\addRectangle @x, @y, @width, @height
            box.model = @
            @collider\addToGroup(collision_group, box)


        elseif @shape_name == 'ellipse'
            @width  = sensor_obj.width
            if @width <= 0 then @width = 14

            circle = @collider\addCircle @x, @y, @width
            circle.model = @
            @collider\addToGroup(collision_group, circle)


        elseif @shape_name == 'polyline'
            -- Translate the relative-to-start coordinates
            -- to normal coords
            @vertices = [{x: pt.x + @x, y: pt.y + @y} for pt in *sensor_obj.polyline ]

            @lines = [{@vertices[i], @vertices[i+1]} for i = 1,#@vertices - 1 ]

            @vertices = [c for v in *@vertices for c in *{v.x, v.y}]

            -- Create a triangle that closely approximates a line
            -- as HardonCollider does not have line collision objects
            create_line = (L) ->
                line = @collider\addPolygon(L[1].x, L[1].y, L[2].x, L[2].y, (L[1].x + L[2].x) * 0.5, (L[1].y + L[2].y) * 0.5 + .001)
                line.model = @
                @collider\addToGroup(collision_group, line)

            _.map(@lines, create_line)

        elseif @shape_name = 'polygon'
            @vertices = [{pt.x + @x, pt.y + @y} for pt in *sensor_obj.polygon ]


            @vertices  = [c for v in *@vertices for c in *v]

            polygon = @collider\addPolygon(unpack @vertices)
            polygon.model = @
            @collider\addToGroup(collision_group, polygon)

        else
        	error 'Unknown shape!'

    reset: () =>
    	@detected = false

    collide: (dt, sensor_physics, other_physics, mx, my) =>
    	@detected = true

    update: (dt) =>
        @detected = false

