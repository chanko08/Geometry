Constants = require 'constants'
vector    = require 'lib/HardonCollider/vector-light'

export BulletModel

class BulletModel
	new: (gun, bullet_type, fire_position, crosshair)=>
		@type       = bullet_type
		@gun        = gun
		@collider   = @gun.owner.collider
		@x          = fire_position.x
		@y          = fire_position.y
		@model_type = 'bullet'

		@dir_x, @dir_y = vector.normalize(crosshair.x - @x, crosshair.y - @y)

	update: (dt) =>

	collide: (dt, A, B, mx, my) =>

		print "PEW PEW PEW PEW PEW!"

		