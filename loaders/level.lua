local class   = require 'lib.hump.class'
local _       = require 'lib.underscore'
-- local Entity = require('entity')


local function load_level( manager, systems, lvl_file_path )
    local dir = "components"
    local part_files = love.filesystem.getDirectoryItems("components")

    -- local components = {}
    -- for i,cfile in ipairs(part_files) do
        
    --     component_key = cfile:match("([^.]+)")
        
    --     components[component_key] = love.filesystem.load(dir..'/'..cfile)()
        
    -- end

    print(lvl_file_path)
    local lvl = love.filesystem.load(lvl_file_path)()

    local entities = {}

    for i,layer in ipairs(lvl.layers) do
        if layer.type == 'objectgroup' then
            for j, obj in ipairs(layer.objects) do
                local comps = {}
                comps.lifetime = 0
                comps.name     = obj.name

                for comp_name,comp_data in pairs(obj.properties) do
                    print('component name: '..comp_name)
                    local sys = systems[comp_name]
                    local status, err = pcall(
                            function()
                                comps[comp_name] = sys:build_component(layer, obj, comp_data)
                                comps[comp_name].entity = comps
                            end
                        )
                    
                    if err then
                        print(err)
                        print('ERRORING COMPONENT: '..comp_name)
                        print(inspect(comp_data))
                    end
                end

                manager:add_entity(comps)
                --table.insert(entities, entity)
                -- print(inspect(entity))
            end

        end
    end
end

return load_level