Constants   = require 'constants'

inspect     = require 'lib/inspect'
_           = require 'lib/underscore'
tween       = require 'lib/tween'

physics 	= require 'systems/physics_system'

export *


class GruntAI
	new: (grunt) =>
		@grunt = grunt
		@move_direction = Constants.Direction.STOP

	update: (dt) =>
		player = @grunt.sensors.player_visible.detected
		if player
			if player.x > @grunt.x
				@move_direction = Constants.Direction.RIGHT
			elseif player.x < @grunt.x
				@move_direction = Constants.Direction.LEFT
			else
				@move_direction = Constants.Direction.STOP

		@grunt\move(@move_direction)

		if (@move_direction == Constants.Direction.LEFT and not @grunt.sensors.cliff_left.detected) or (@move_direction == Constants.Direction.RIGHT and not @grunt.sensors.cliff_right.detected)
			@grunt\stop_move(@move_direction) 
		

