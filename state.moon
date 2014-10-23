PQ = require 'lib/loop/collection/PriorityQueue'

class State
    new: () =>
    	@systems = {
    		priority: {
    			system: nil
    			events: nil
    		}

    	}
    	@entities = {}
    	@message_center = {}

    broadcast: (message, message_obj) =>
    	if @message_center[message]
    		table.insert(@message_center.messages[message].queue, message_obj)

    	if message == 'UPDATE'
    		--flush queues
			for system_events in PQ.sequence(@systems)
				ev_queues = {}
    			for i, event_key in ipairs(system_events.events)
    				ev_queues[event_key] = @message_center.messages[event_key].queue
    			
    			system_events.system\recieve(ev_queues)

    		
    		--@message_center.messages[event_key].queue = {}

    	

    	

return State