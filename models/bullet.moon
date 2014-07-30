HC     = require 'lib/HardonCollider'
vector = require 'lib/HardonCollider/vector-light'
tween  = require 'lib/tween'

Constants = require 'constants'

class BulletModel
	new: (bullet_data, level, id)=>
		@id = id
		@model_type = 'bullet'

		@x = bullet_data.orig_x
		@y = bullet_data.orig_y
		@r = bullet_data.radius
		@prev_x = @x
		@prev_y = @y

		
		@dir_x, @dir_y = vector.normalize(bullet_data.dir_x-@x,bullet_data.dir_y-@y)

		@end_x = @x + Constants.MAX_BULLET_RANGE*@dir_x
		@end_y = @y + Constants.MAX_BULLET_RANGE*@dir_y

		@duration = Constants.MAX_BULLET_RANGE / bullet_data.speed

		@collider = level.collider
		@collider_shape = @collider\addCircle(@x, @y, @r)
		@collider_shape.model = @

		-- print @end_x, @end_y
		-- print @dir_x, @dir_y
		-- print @duration
		@movement = tween.new(@duration, @, {x: @end_x, y: @end_y}, 'linear')

		@level = level

	update: (dt) =>
		if @dead
			@level\remove_model('bullet', @id)
			@collider\remove(@collider_shape)
		else
			@movement\update(dt)
			@collider_shape\move(@x - @prev_x, @y - @prev_y)
			-- print "(#{@prev_x},#{@prev_y}) -> (#{@x},#{@y})"

			@prev_x = @x
			@prev_y = @y
			--print "bullet update"
			--print @x, @y

	collide: (dt, A, B, mx, my) =>

		if B.model and (B.model.model_type == 'player' or B.model.model_type == 'bullet')
			return

		print "PEW PEW PEW PEW PEW!"
		@dead = true

		