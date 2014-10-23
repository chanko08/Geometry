Hub     = require 'hub'
inspect = require 'lib/inspect'
vector  = require 'lib/hump/vector'

class PhysicsSystem extends Hub
	new: (manager) =>
		super(manager)
		@\register('update')
		

	update: (entity_manager, dt) =>
		--some stuff here
		entities = entity_manager\get_connection_hubs('physics')

		for i,ent in ipairs(entities)
			@\physics(ent,dt)


	physics: (ent, dt) =>
	    max_velocity = ent.max_velocity or  math.huge
	    

	    s = ent.physics.s
	    v = ent.physics.v
	    a = ent.physics.a

	    s = s + dt * v
	    v = v + dt * a
	    v = v\trimmed(max_velocity)


	    ent.physics.s = s
	    ent.physics.v = v

	    return ent

	register: (connection, to) =>
		super(connection)
		print('to', inspect(to))
		return to