local class = require('lib.hump.class')

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
    if not self.values[val]
        print('WARNING: '..tostring(val)..' is not around to be removed. You should probably look into this.' )
    end
    self.values[val]=nil
end

function Set:contains(val)
    return self.values[val] == true
end

return Set