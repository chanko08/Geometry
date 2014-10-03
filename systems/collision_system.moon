Hub     = require 'hub'
HC      = require 'lib/HardonCollider'
inspect = require 'lib/inspect'

class CollisionSystem extends Hub
	new: () =>
		@\register('update')

		on_collision = (dt, A, B, mx, my) ->
            @on_collision(dt, A, B, mx, my)

        on_stop_collision = (dt, A, B) ->
            @on_stop_collision(dt, A, B)

		@collider = HC(100, on_collision, on_stop_collision)

	update: (entity_manager, dt) =>
		@collider\update dt

		ents = entity_manager\get_connection_hubs('collision')


	on_collision: (dt, A, B, mx, my) =>
		if A.model.model_type == 'sensor' and B.model.model_type == 'sensor'
            return
        elseif A.model.model_type == 'sensor'
            A.model\collide(dt, A, B, mx, my)
        elseif B.model.model_type == 'sensor'
            B.model\collide(dt, B, A, mx, my)
        elseif not @collider\isPassive(B) 
            A.model\collide(dt, A, B, mx/2, my/2)
            B.model\collide(dt, B, A, -mx/2, -my/2)
        else
            A.model\collide(dt, A, B, mx, my)

	on_stop_collision: (dt, A, B) =>
		if A.model.model_type == 'sensor' and B.model.model_type == 'sensor'
            return
        elseif A.model.model_type == 'sensor'
            A.model\stop_collide(dt, A, B)
        elseif B.model.model_type == 'sensor'
            B.model\stop_collide(dt, B, A)
        elseif not @collider\isPassive(B) 
            A.model\stop_collide(dt, A, B)
            B.model\stop_collide(dt, B, A)
        else
            A.model\stop_collide(dt, A, B)


    register: (connection, shape_info) =>
    	@super(connection)
    	shape = nil
    	if shape_info.shape == 'circle'
    		shape = @collider\addCircle(shape_info.s.x, shape_info.s.y, shape_info.radius)

    	for k,grp in ipairs(shape_info.groups)
	    	@collider\addToGroup(grp, shape)
        

        if shape_info.passive
        	@collider\setPassive shape

		shape.model = @
        return shape


