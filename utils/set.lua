local class = require('lib.hump.class')
local _     = require('lib.underscore')

local Set = class({})

function Set:init(values,use_weak_refs)
    local weak = use_weak_refs or false
    local vals = values or {}

    local meta = {}
    self.values = {}

    if weak then
        meta.__mode = 'k'
    end

    setmetatable(self.values, meta)

    for i,v in ipairs(values) do
        self.values[v] = true
    end
end

function Set:add(val)
    self.values[val] = true
end

function Set:remove(val)
    if not self.values[val] then
        print('WARNING: '..tostring(val)..' is not around to be removed. You should probably look into this.' )
    end
    self.values[val] = nil
end

function Set:contains(val)
    return self.values[val] == true
end

function Set:iter()
    local i = 0
    local ks = _.keys(self.values)
    local n = #ks
    
    return function()
        i = i + 1
        local k = ks[i]
        
        if i <= n then return k end
    end    
end

return Set