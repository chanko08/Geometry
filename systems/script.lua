local System = require 'systems.system'
local HC     = require 'lib.HardonCollider'
local ScriptEngine = class({})
ScriptEngine:include(System)


function ScriptEngine:init( )
    System.init(self)

end


local function run_script(dt, entity)
    entity.time_delta = dt
    
    for i, script in ipairs(entity.scripts) do
        if type(script) == 'string' then
            entity.scripts[i] = loadfile(script, nil, entity)
        else

            script()
        end
    end
end

function ScriptEngine:run( ecs, dt )
    ecs:run_with( curry(run_script, dt), {'scripts'} )
end

return ScriptEngine