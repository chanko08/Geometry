local DefaultDict = require('util.defaultdict')
local ECS = class({})


function ECS:init( ... )
    -- body
    self.next_id = 1
    self.entities   = {}
    self.components = DefaultDict(function() return {} end)
    self.staged_for_deletion_ents = {}
    self.recently_added_ents = {}

end

function ECS:add_entities(ents)
    for i,e in ipairs(ents) do
        self.entities[self.next_id] = e
        self:_add_components(self.next_id, e)
        push(self.recently_added_ents, self.next_id)

        self.next_id = self.next_id + 1
    end
end

function ECS:recently_added()
    return map(self.recently_added_ents, curry(self.get_entity, self))
end

function ECS:staged_for_deletion( )
    return map(self.staged_for_deletion_ents, curry(self.get_entity, self))
end

function ECS:update()
    


    for i,ent_id in ipairs(self.staged_for_deletion_ents) do
        local e = self.entities[ent_id]
        self.entities[ent_id] = nil
        for comp_name, comp in pairs(e) do
            self.components:get(comp_name)[ent_id] = nil
        end
    end

    self.staged_for_deletion_ents = {}
    self.recently_added_ents = {}
end

function ECS:_add_components( ent_id, ent )
    for comp_name,comp in pairs(ent) do
        self.components:get(comp_name)[ent_id] = comp
    end
end

function ECS:remove_entity(ent_id)
    push(self.staged_for_deletion_ents, ent_id)
end

function ECS:get_entity( ent_id )
    return self.entities[ent_id]
end

function ECS:run_with(f, required_components, filter_func)
    map(self:_find_ents(required_components, filter_func), f)
end

function ECS:_find_ents( components, f )
    f = f or function (...) return true end

    if #components == 0 then
        error('Requested entities without any components specified.')
    end

    ents = keys(self.components:get(components[1]))
    ents = map(ents, curry(self.get_entity, self))

    -- print(inspect(ents))

    if #components > 1 then

        local filt = function(ent)
            for i=2,#components do
                if not self.entities[ent_id][components[i]] then
                    return false
                end
            end
            return f(ent)
        end

        ents = _.filter(ents, filt)
    end
    return ents
end

return ECS