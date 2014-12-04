local class  = require('lib.hump.class')
local Signal = require('lib.hump.signal')

local Set    = require('utils.set')

local EntityManager = class({})

function EntityManager:init()
    self.entities = Set({}, false)
    self.signals  = Signal.new()
end

function EntityManager:register(system_type, system)
    local f = function(e) system:add_entity(e) end
    self.signals:register(system_type, f)
end

function EntityManager:broadcast(system_type, entity)
    self.entities:add(entity)
    self.signals:emit(system_type, entity)
end

function EntityManager:remove(entity)
    self.entities:remove(entity)
end

function EntityManager:getEntities(name)
    print("in get entities")
    local es = {}
    for i,ent in ipairs(self.entities:items()) do
        print("FUCKFUCK" .. ent.name)
        if ent.name == name then
            table.insert(es, ent)
        end
    end
    return es
    -- return _.filter(
    --     self.entities:items(),
    --     function ( ent )
    --         print("\t\tFUCKFUCK "..ent.name)
    --         return ent.name == name
    --     end
    -- )
end

return EntityManager