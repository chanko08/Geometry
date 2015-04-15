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

function EntityManager:init(entity_loader,state)
    --self.entities = Set({})
    self.state = state

    self.prototypes         = prototypes or {}
    self.entity_set         = Set({})
    self.component_sets     = {}
    self.tag_sets           = {}
    self.signals            = Signal.new()
    
    self.marked_for_removal = Set({})
end


function EntityManager:register(system_type, system)
    --local f = function(e) system:add_entity(e) end
    --self.signals:register(system_type, f)
end

function EntityManager:get_entities( component_name )
    local function get_ent(comp)
        return comp.entity
    end


    if component_name == '' then
        return self.entity_set:items()
    end

    return get_entities(self.component_sets[component_name], get_ent)
end

function EntityManager:add_entity( entity )
    for k,comp in pairs(entity) do
        if k ~= 'lifetime' and k~= 'name' then
            if not self.component_sets[k] then
                self.component_sets[k] = Set({})
            end

            self.component_sets[k]:add(comp)
        end

        if k == 'hashtag' then
            self:add_entity_tags(comp, entity)
        end
    end

    self.entity_set:add(entity)
end

function EntityManager:construct_entity(entity_data, prototype)
    return self.entity_loader:from_prototype(entity_data, prototype)
end

function EntityManager:add_entity_tags( comp, entity )
    for i, tag in ipairs(comp.tags) do
        if not self.tag_sets[tag] then
            self.tag_sets[tag] = Set({})
        end

        self.tag_sets[tag]:add(entity)
    end
end

function EntityManager:get_entities_by_tag( tag )
    if tag == '' then
        return self.entity_set:items()
    end

    return get_entities(self.tag_sets[tag], _.identity)
end

function EntityManager:get_entities_by( filter )
    filter.tag       = filter.tag       or ''
    filter.component = filter.component or ''
    
    local by_tag  = self:get_entities_by_tag(filter.tag)
    local by_comp = self:get_entities(filter.component)

    -- logi('manager', by_tag)
    -- logi('manager', by_comp)

    return _.filter(by_tag, _.curry(_.include, by_comp))
end

-- TODO 
function EntityManager:remove_entity_tags( entity )
    log('item', 'removing tags')
    for i,tag in ipairs(entity.hashtag.tags) do
        log('item', 'tag name', tag)
        self.tag_sets[tag]:remove(entity)
    end
end

-- TODO
function EntityManager:remove_entity_components( entity )
    log('item', 'removing components')
    for comp_name,comp_data in pairs(entity) do
        if comp_name ~= 'lifetime' and comp_name ~= 'name' then
            log('item', 'comp name', comp_name)
            self.component_sets[comp_name]:remove(comp_data)
        end
    end
end

function EntityManager:remove(entity)
    self.entity_set:remove(entity)
    self:remove_entity_tags(entity)
    self:remove_entity_components(entity)

end

function EntityManager:mark_for_removal(entity)
    self.marked_for_removal:add(entity)
end

function EntityManager:remove_dead_ents()
    for i,ent in ipairs(self.marked_for_removal:items()) do
        if ent.collision then
            self.state.relay:emit('remove_collision_shape',ent.collision)
        end
        self:remove(ent)
    end
    self.marked_for_removal = Set({})
end

return EntityManager