<<<<<<< Updated upstream
local ECS = class{}

function ECS:init(systems)
    self.entities_to_add = {}
    self.entities_to_remove = {}
    self.entities = {}

    self.systems = systems or {}
end

function ECS:add_entity( e )
    table.insert(self.entities_to_add, e)

end

function ECS:remove_entity( e )
    table.insert(self.entities_to_remove, e)
end


local function remove_entity( es, e )
    if not es[e] then
        return
    end

    es[e] = nil
    _.each(e.systems, function(sys)
        sys:on_remove(e)
        sys.entities[e] = nil
    end)
end

local function add_entity( es, e )
    es[e] = e
    _.each(e.systems, function(sys)
        if passes_filter(sys.filter, e) then
            sys:on_add(e)
            sys.entities[e] = e
        end
    end)
end

local function update_system(dt, sys)
    _.each(sys.entites, _.curry(sys.update, sys, dt))
end

function ECS:update(dt)
    _.each(self.entities_to_remove, _.curry(remove_entity, self.entities))
    _.each(self.entities_to_add,    _.curry(add_entity,    self.entities))


    _.each(self.systems, _.curry(update_system, dt))
=======
local ECS = class({})

function ECS:init(systems)
    self.systems = systems or {}

    --initialize a list for each system that will contain that system's entities
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
>>>>>>> Stashed changes
end

return ECS