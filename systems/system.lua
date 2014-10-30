local class = require('lib.hump.class')
local Set   = require('utils.set')

local System = class({})

function System:init( manager )
    self.manager  = manager
    self.entities = Set({},true) 
end

function System:add_entity( e )
    
    self.entities:add(e)
end

function System:run( ... )
    -- body
end



return System 