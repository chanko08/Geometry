--[[
    ECS (Entity Component System) class
    ===========================================================================
    An `ECS` object manages the game world's entities and systems.

    Specifically, it allows systems to the following:
    * Update only the entities that the system says it will update (by the
      systems use of a `filter`)
    * Adds and removes entities from the world in a way such that there will be
      no chances of a system working on a entity that does not exist
    * Updates systems in the order that the ECS was given them (this is helpful
      when it comes to systems that possibly depend on others)


    Typically, I would expect there to be only one instantiation of an ECS per
    game state.
    If more than one is used in a given state than I would be careful of the
    following:
    * Sharing entities between the different worlds. Since Lua passes tables by
      reference things will get hairy here if sharing starts.
    * Order of `ECS` object updates. Changing the order the worlds update could
      result in odd effects if systems from these different worlds depend on
      each other.
]]

local ECS = class({})

function ECS:init(systems)
    self.systems = systems or {}

    -- ECS will maintain the lists of entities for each system to maintain
    -- ownership of the entities 
    self.system_entities = {}
    _.each(self.systems, function(s) self.system_entities[s] = {} end)

    self.entities_to_add    = {}
    self.entities_to_remove = {}
    self.entities           = {}
end

function ECS:add_entity( e )
    _.push(self.entities_to_add, e)
end

function ECS:remove_entity( e )
    _.push(self.entities_to_remove, e)
end

--[[
    ECS:update
    ===========================================================================
    * Processes entities that have been added or removed from the world
    * Notifies systems that use those entities if they have been added or removed
    * Calls update function on each system with their entities
]]
function ECS:update(dt)
    

    local function process_entities(entity_filter, entity_process)
        _.(self.systems):chain():filter(entity_filter):each(entity_process)
    end


    local function add_entity( e )
        assert(self.entities[e] == nil, "trying to add an entity that already exists")

        local function add_entity_to_system(system)
            self.system_entities[system][e] = e
            system:on_add(e)
        end

        local function has_component(component, entity)
            return entity[component] ~= nil
        end

        local function entity_matches_system_filter(entity, system)
            local has_component = _.curry(has_component, entity)
            return _.(system.filter):chain():map(has_component):all():value()
        end

        self.entities[e] = e
        process_entities(entity_matches_system_filter, add_entity_to_system)
    end

    local function remove_entity( e )
        assert(self.entities[e] ~= nil, "trying to remove an entity that does not exist")


        local function system_uses_entity(system)
            return self.system_entities[system][e] ~= nil
        end

    

        local function remove_entity_from_system(system)
            self.system_entities[system][e] = nil
            system:on_remove(e)
        end

        self.entities[e] = nil

        process_entities(system_uses_entity, remove_entity_from_system)
    end

    local function update_system(sys)
        _.each(self.system_entities[sys], _.curry(sys.update, sys, dt))
    end


    _.each(self.entities_to_remove, remove_entity)
    _.each(self.entities_to_add,    add_entity)
    _.each(self.systems,            update_system)
end

return ECS