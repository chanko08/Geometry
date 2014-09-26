Constants   = require 'constants'

inspect     = require 'lib/inspect'
_           = require 'lib/underscore'
tween       = require 'lib/tween'


export *


class Sensor
	new: (model, target_fun, collision_group, sensor_obj) =>
		@model = model

        @model_type = 'sensor'

        @is_target = (self, t) -> target_fun(t)

        @x, @y          = @model\get_center!
        @shape_name     = sensor_obj.shape
        @properties     = sensor_obj.properties
        @collider       = @model.collider

        @collider_shapes = nil

        @detected   = false

		if @shape_name == 'rectangle'
            @width  = sensor_obj.width
            @height = sensor_obj.height

            @collider_shapes = {@collider\addRectangle(@x + sensor_obj.x, @y + sensor_obj.y, @width, @height)}


        elseif @shape_name == 'ellipse'
            @width  = sensor_obj.width
            if @width <= 0 then @width = 14

            @collider_shapes = {@collider\addCircle(@x, @y, @width)}


        elseif @shape_name == 'polyline'
            -- Translate the relative-to-start coordinates
            -- to normal coords
            @vertices = [{x: pt.x + @x, y: pt.y + @y} for pt in *sensor_obj.polyline ]

            @lines = [{@vertices[i], @vertices[i+1]} for i = 1,#@vertices - 1 ]

            @vertices = [c for v in *@vertices for c in *{v.x, v.y}]

            -- Create a triangle that closely approximates a line
            -- as HardonCollider does not have line collision objects
            create_line = (L) ->
                @collider\addPolygon(L[1].x, L[1].y, L[2].x, L[2].y, (L[1].x + L[2].x) * 0.5, (L[1].y + L[2].y) * 0.5 + .001)

            @collider_shapes = _.map(@lines, create_line)

        elseif @shape_name = 'polygon'
            @vertices = [{pt.x + @x, pt.y + @y} for pt in *sensor_obj.polygon ]


            @vertices  = [c for v in *@vertices for c in *v]

            @collider_shapes = {@collider\addPolygon(unpack @vertices)}

        else
        	error 'Unknown shape!'

        for k, shape in ipairs @collider_shapes
            shape.model = @
            @collider\addToGroup(collision_group, shape)

    reset: () =>
    	@detected = nil

    collide: (dt, sensor_physics, other_physics, mx, my) =>
        if @is_target(other_physics)
        	@detected = other_physics.model

    stop_collide: (...) =>
        @detected = nil

    update: (dt) =>
        newx,newy = @model\get_center!
        for k, shape in ipairs @collider_shapes
            shape\move newx-@x, newy-@y
        @x,@y = newx,newy

