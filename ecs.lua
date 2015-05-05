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
end

return ECS