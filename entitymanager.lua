local class  = require('lib.hump.class')
local Signal = require('lib.hump.signal')

local Set    = require('utils.set')


local EntityManager = class({})

function EntityManager:init()
    --self.entities = Set({}, false)
    self.component_sets = {}
    self.signals  = Signal.new()
end


function EntityManager:register(system_type, system)
    --local f = function(e) system:add_entity(e) end
    --self.signals:register(system_type, f)
end

function EntityManager:get_entities( component_name )
    local function get_ent(comp)
        return comp.entity
    end

    return _.map(self.component_sets[component_name]:items(), get_ent)
end

function EntityManager:add_entity( entity )
    for k,comp in pairs(entity) do
        if k ~= 'lifetime' then
            if not self.component_sets[k] then
                self.component_sets[k] = Set({}, false)
            end

            self.component_sets[k]:add(comp)
        end
    end
end

--[[
function EntityManager:broadcast(system_type, entity)
    self.entities:add(entity)
    self.signals:emit(system_type, entity)
end
--]]

function EntityManager:remove(entity)
    self.entities:remove(entity)
end

return EntityManager