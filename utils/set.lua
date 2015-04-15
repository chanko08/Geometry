local class = require('lib.hump.class')
local _     = require('lib.underscore')

local Set = class({})

function Set:init(values)
    local vals = values or {}

    self.values = {}

    for i,v in ipairs(values) do
        self.values[v] = true
    end
end

function Set:add(val)
    self.values[val] = true
end

function Set:remove(val)
    if self.values[val] == nil then
        print('WARNING: '..tostring(val)..' is not around to be removed. You should probably look into this.' )
    end
    self.values[val] = nil
end

function Set:contains(val)
    return self.values[val] == true
end

function Set:items()
    local ks = _.keys(self.values)
    
    return ks
end

return Set