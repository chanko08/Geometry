Constants = require 'constants'

export BulletModel

class BulletModel
	new: (gun, bullet_type, fire_position, crosshair)=>
		@type = bullet_type
		@gun = gun
		@x = fire_position.x
		@y = fire_position.y

		@dir_x, @dir_y = vector.normalize(crosshair.x - @x, crosshair.y - @y)

	update: (dt) =>

	collide: (dt, A, B, mx, my) =>

		if B.model and (B.model.model_type == 'player' or B.model.model_type == 'bullet')
			return

		print "PEW PEW PEW PEW PEW!"

		