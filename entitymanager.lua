local class  = require('lib.hump.class')
local Signal = require('lib.hump.signal')

local Set    = require('utils.set')


local function get_entities( search_space, accessor )
    if search_space then
        return _.map(search_space:items(), accessor)
    else
        return {}
    end
end



local EntityManager = class({})

function EntityManager:init(entity_loader)
    --self.entities = Set({}, false)
    self.prototypes = prototypes or {}
    self.component_sets = {}
    self.tag_sets = {}
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

    return get_entities(self.component_sets[component_name], get_ent)
end

function EntityManager:add_entity( entity )
    for k,comp in pairs(entity) do
        if k ~= 'lifetime' then
            if not self.component_sets[k] then
                self.component_sets[k] = Set({}, false)
            end

            self.component_sets[k]:add(comp)
        end

        if k == 'hashtag' then
            self:add_entity_tags(comp, entity)
        end
    end
end

function EntityManager:construct_entity(entity_data, prototype)
    return self.entity_loader:from_prototype(entity_data, prototype)
end

function EntityManager:add_entity_tags( comp, entity )
    for i, tag in ipairs(comp.tags) do
        if not self.tag_sets[tag] then
            self.tag_sets[tag] = Set({}, false)
        end

        self.tag_sets[tag]:add(entity)
    end
end

function EntityManager:get_entities_by_tag( tag )
    return get_entities(self.tag_sets[tag], _.identity)
end



-- TODO 
function EntityManager:remove_entity_tags( entity )
end

-- TODO
function EntityManager:remove_entity_components( entity )
end

function EntityManager:remove(entity)
    self.remove_entity_components(entity)

    self:remove_entity_tags(entity)

end

return EntityManager