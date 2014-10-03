inspect = require 'lib/inspect'

class HubManager
	new: () =>
		-- stores tables with the system id as key, and a table of entity ids as the value
		@connections = {}
		@hubs = {}


	register: (connection, hub) =>
		print 'hub: ', hub.__class.__name
		print 'self: ', @.__class.__name
		print 'connection: ', connection
		if not @connections[connection]
			@connections[connection] = {}
		@connections[connection][hub] = true

	unregister: (connection, hub) =>
		if not @connections[connection]
			return
		@connections[connection][hub] = nil	


	destroy: (hub) =>
		for k,connection in ipairs(hub.registered_connections)
			@connections[connection][hub] = nil
			
	get_connection_hubs: (connection) =>
		connection_hubs = {}
		for k,entities in pairs(@connections[connection])
			table.insert(connection_hubs, k)

		return connection_hubs