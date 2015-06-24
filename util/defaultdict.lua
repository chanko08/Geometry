
local DefaultDict = class({})

function DefaultDict:init( default_constructor )
    self.dict = {}
    self.constructor = default_constructor
end

function DefaultDict:get(key)
    if self.dict[key] then
        return self.dict[key]
    end

    local d = self.constructor()
    self.dict[key] = d
    return d
end

function DefaultDict:set(key, value)
    self.dict[key] = value

    return value
end

return DefaultDict