local class = require('lib.hump.class')
local Set   = require('utils.set')

local System = class({})

function System:init(entity_manager)
    self.manager  = entity_manager
    self.entities = Set({}, true)
end

function System:add_entity(entity)
    self.entities:add(entity)
end

function System:execute(...)
end


return System