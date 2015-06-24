--[[
    Think of `System` as a thing that modifies the
    set of components it claims to modify/use.
]]

local System = class({})

function System:run(ecs, dt)
end

return System