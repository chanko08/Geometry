HubManager    = require('managers/hub_manager')
EntityManager = require('managers/entity_manager')

class SystemManager extends HubManager
	new: () =>
		super!
		@entity_manager = EntityManager()