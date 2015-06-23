local DefaultDict = require('util.defaultdict')
local ECS = class({})


function ECS:init( ... )
    -- body
    self.next_id = 0
    self.entities   = {}
    self.components = DefaultDict(function() return {} end)
end

function ECS:add_entities(ents)
    for i,e in ipairs(ents) do
        self.entities[self.next_id] = e
        self:_add_components(self.next_id, e)

        self.next_id = self.next_id + 1
    end
end

function ECS:_add_components( ent_id, ent )
    for comp_name,comp in pairs(ent) do
        self.components:get(comp_name)[ent_id] = comp
    end
end


function ECS:remove_entity(ent_id)
    local e = self.entities[ent_id]
    self.entities[ent_id] = nil
    for comp_name, comp in pairs(e) do
        self.components:get(comp_name)[ent_id] = nil
    end
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

    ents = _.copy(self.components:get(components[1]))

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