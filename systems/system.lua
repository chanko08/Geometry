local class = require('lib.hump.class')
local Set   = require('utils.set')

local System = class({})

function System:init( state )
    self.entities = Set({},true)

    self.event_queue = {} 
    
    self.manager     = state.manager
    self.relay       = state.relay
    
    self.input       = state.input
    self.graphics    = state.graphics
    self.audio       = state.audio   
    self.log         = state.log     
    self.savegame    = state.savegame
    self.camera      = state.camera  
end

--[[function System:add_entity( e )
    
    self.entities:add(e)
end]]

function System:get_entities(component)
    return self.manager:get_entities(component)
end

function System:run( ... )
    -- body
end

function System:build_component( obj, comp_data )
end

function System:listen_for(event)
    local insert = function(self, ev)
        table.insert(self.event_queue, ev)
    end

    -- FEED MEEEEE
    self.relay:register(event, _.curry(insert, self))
end


return System 