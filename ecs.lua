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
    local function passes_filter( filters, e )
        _.(filters):chain():map(function(f) return e[f] end):all():value()  
    end

    local function add_entity( e )
        self.entities[e] = e

        _.each(self.systems, function(sys)
            if passes_filter(sys.filter, e) then
                sys:on_add(e)
                self.system_entities[sys] = e
            end
        end)
    end

    local function remove_entity( e )
        if not self.entities[e] then
            return
        end

        es[e] = nil
        _.each(self.systems, function(sys)
            if self.system_entities[e] ~= nil then
                sys:on_remove(e)
                self.system_entities[sys] = nil
            end
        end)
    end

    local function update_system(sys)
        _.each(self.system_entities[sys], _.curry(sys.update, sys, dt))
    end


    _.each(self.entities_to_remove, remove_entity)
    _.each(self.entities_to_add,    add_entity)
    _.each(self.systems,            update_system)
end

return ECS