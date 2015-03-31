local class = require('lib.hump.class')
local Set   = require('utils.set')

local System = class({})

function System:init( state )
    self.entities = Set({},true)

    self.event_queue = {}
    self.subsystems  = {}
    
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

function System:run( dt )
    for i,subsystem in ipairs(self.subsystems) do
        subsystem:run(dt)
    end
end

function System:build_component( obj, comp_data )
end

function System:add_subsystem( system )
    table.insert(self.subsystems, system)
end

function System:listen_for(event_name)
    local insert = function(self, name, source_entity, ...)
        table.insert(self.event_queue, {name=name, ent=source_entity, info={...}})
    end

    -- FEED MEEEEE
    self.relay:register(event_name, _.curry(_.curry(insert,self), event_name))
end


return System 