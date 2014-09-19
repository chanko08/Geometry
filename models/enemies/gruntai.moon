Constants   = require 'constants'

inspect     = require 'lib/inspect'
_           = require 'lib/underscore'
tween       = require 'lib/tween'

physics = require 'systems/physics'

export *


class GruntAI
	new: (grunt) =>
		@grunt = grunt

	update: () =>
		
