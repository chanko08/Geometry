class Hub
	new: (manager) =>
		@manager = manager
		@connections = {}

	register: (connection, ...) =>
		@connections[connection] = true
		@manager\register(connection, @, ... )

	unregister: (connection) =>
		@manager\unregister(connection, @)
		@connections[connection] = nil

	destroy: () =>
		@manager\destroy_entity(@)