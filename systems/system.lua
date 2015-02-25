local class = require('lib.hump.class')
local Set   = require('utils.set')

local System = class({})

function System:init( manager )
    self.manager  = manager
    self.entities = Set({},true) 
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



return System 