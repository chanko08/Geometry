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
end

return ECS