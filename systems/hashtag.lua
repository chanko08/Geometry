local System           = require('systems.system')
local HashtagComponent = require('components.hashtag')

local HashtagSystem = class({})
HashtagSystem:include(System)

function HashtagSystem:init(state)
    System.init(self,state)
end

function HashtagSystem:run(dt)
end

function HashtagSystem:build_component( ... )
    return HashtagComponent( ... )
end

return HashtagSystem